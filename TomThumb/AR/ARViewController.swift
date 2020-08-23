//
//  ARViewController.swift
//  TomThumb
//
//  Created by Andrea Re on 13/07/2020.
//  Copyright © 2020 Sora. All rights reserved.
//

import Foundation
import ARCL
import ARKit
import MapKit
import SceneKit
import UIKit
import SwiftUI
import Firebase
import FirebaseDatabase

final class ARViewController: UIViewController, UIViewControllerRepresentable {
    var sceneLocationView: SceneLocationView?
    
    //This is for the `SceneLocationView`. There's no way to set a node's `locationEstimateMethod`, which is hardcoded to `mostRelevantEstimate`.
    public var locationEstimateMethod = LocationEstimateMethod.mostRelevantEstimate
    
    public var arTrackingType = SceneLocationView.ARTrackingType.worldTracking
    public var scalingScheme = ScalingScheme.normal
    
    // These three properties are properties of individual nodes. We'll set them the same way for each node added.
    public var continuallyAdjustNodePositionWhenWithinRange = true
    public var continuallyUpdatePositionAndScale = true
    public var annotationHeightAdjustmentFactor = 1.0
    
    public var renderTime: TimeInterval = 0
    private let distanceThreshold: Double = 10.0
    private var isColliding = false
    
    private var isPlaying = false
    @Binding var nPlays: Int
    
    var route: Route
    @Binding var actualCrumb: Int
    //TEST var for distance point-segment
    @Binding var prevCrumb: LocationNode
    @Binding var lookAt: Int
    var locationManager = LocationManager()
    
    init(route: Route, actualCrumb: Binding<Int>, lookAt: Binding<Int>, prevCrumb: Binding<LocationNode>, nPlays: Binding<Int>) {
        self.route = route
        self._actualCrumb = actualCrumb
        self._lookAt = lookAt
        self._prevCrumb = prevCrumb
        self._nPlays = nPlays
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle and actions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneLocationView = SceneLocationView()
        guard let locationService = locationManager.locationManager else { return }
        
        locationService.startUpdatingLocation()
        view.addSubview(sceneLocationView!)
    }
    
    func rebuildSceneLocationView() {
        sceneLocationView?.removeFromSuperview()
        let newSceneLocationView = SceneLocationView.init(trackingType: arTrackingType, frame: view.frame, options: nil)
        newSceneLocationView.translatesAutoresizingMaskIntoConstraints = false
        newSceneLocationView.arViewDelegate = self
        newSceneLocationView.locationEstimateMethod = locationEstimateMethod
        newSceneLocationView.allowsCameraControl = true
        newSceneLocationView.debugOptions = []
        newSceneLocationView.showsStatistics = false
        newSceneLocationView.showAxesNode = false // don't need ARCL's axesNode because we're showing SceneKit's
        newSceneLocationView.autoenablesDefaultLighting = true
        newSceneLocationView.isUserInteractionEnabled = false
        view.addSubview(newSceneLocationView)
        sceneLocationView = newSceneLocationView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        rebuildSceneLocationView()
        addJustOneNode()
        sceneLocationView?.run()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        sceneLocationView?.removeAllNodes()
        sceneLocationView?.pause()
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sceneLocationView?.frame = view.bounds
    }
    
    /// Perform these actions on every node after it's added.
    func addScenewideNodeSettings(_ node: LocationNode) {
        if let annoNode = node as? LocationAnnotationNode {
            annoNode.annotationHeightAdjustmentFactor = annotationHeightAdjustmentFactor
        }
        node.ignoreAltitude = true
        node.scalingScheme = scalingScheme
        node.continuallyAdjustNodePositionWhenWithinRange = continuallyAdjustNodePositionWhenWithinRange
        node.continuallyUpdatePositionAndScale = continuallyUpdatePositionAndScale
    }
    
    // Add a single crumb
    func addJustOneNode() {
        guard (self.sceneLocationView?.sceneLocationManager.currentLocation) != nil else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.addJustOneNode()
            }
            return
        }
        guard (self.actualCrumb < self.route.mapRoute.crumbs.count) else {
            terminateAR()
            return
        }
        
        self.sceneLocationView?.removeAllNodes()
        
        let crumbNode = LocationNode(location: self.route.mapRoute.crumbs[self.actualCrumb].location)
        let crumbScene = SCNScene(named: "crumb.dae")
        guard let crumb: SCNNode = crumbScene?.rootNode.childNode(withName: "crumbModel", recursively: true) else {
            fatalError("crumbModel not found")
        }
        
        if actualCrumb == 0 {
            crumb.geometry?.firstMaterial?.diffuse.contents = UIColor.systemRed
        } else if actualCrumb == (self.route.mapRoute.crumbs.count - 1) {
            crumb.geometry?.firstMaterial?.diffuse.contents = UIColor.systemGreen
        }
        
        crumbNode.addChildNode(crumb)
        crumbNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 120, z: 0, duration: 100)))
        self.addScenewideNodeSettings(crumbNode)
        self.sceneLocationView?.addLocationNodeWithConfirmedLocation(locationNode: crumbNode)
    }
    
    func terminateAR() {
        let db = Database.database().reference()
        
        guard let currentLocation = self.sceneLocationView?.sceneLocationManager.currentLocation else { return }
        
        let userLocation = CLLocation(coordinate: currentLocation.coordinate,
        altitude: currentLocation.altitude)
        
        let routeData = [
            "id" : self.route.id as Any,
            "latitude" : userLocation.coordinate.latitude,
            "longitude" : userLocation.coordinate.longitude,
            "collected" : self.actualCrumb
        ]
        db.child("Assisted").setValue(routeData)
        
        print("DEBUG - Crumb index out of bounds, you might have finished the route!")
        viewWillDisappear(false)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ARViewController>) -> ARViewController {
        return ARViewController(route: self.route, actualCrumb: self.$actualCrumb, lookAt: self.$lookAt, prevCrumb: self.$prevCrumb, nPlays: self.$nPlays)
    }
    
    func updateUIViewController(_ uiViewController: ARViewController.UIViewControllerType, context: UIViewControllerRepresentableContext<ARViewController>) {
        //print("Update camera view")
    }
}

// MARK: - ARSCNViewDelegate
extension ARViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // print(#file, #function)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, willUpdate node: SCNNode, for anchor: ARAnchor) {
        // print(#file, #function)
    }
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        // print(#file, #function)
    }
    
    // MARK: - SCNSceneRendererDelegate
    // These functions defined in SCNSceneRendererDelegate are invoked on the arViewDelegate within ARCL's
    // internal SCNSceneRendererDelegate (akak ARSCNViewDelegate). They're forwarded versions of the
    // SCNSceneRendererDelegate calls.
    
    public func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        guard actualCrumb < route.mapRoute.crumbs.count else { return }
        
        guard let currentLocation = self.sceneLocationView?.sceneLocationManager.currentLocation else { return }
        
        guard let locationNodes = sceneLocationView?.locationNodes else { return }
        
        guard locationNodes.count > 0 else { return }
        
        let userLocation = CLLocation(coordinate: currentLocation.coordinate,
                                      altitude: currentLocation.altitude)
        
        if time > renderTime {
            // Instance for DB firebase
            let db = Database.database().reference()
            
            /* Ogni 0.75s pubblica sul db:
                - id del percorso (possiamo eseguire solo i percorsi della factory)
                - posizione assistito (lat, lon)
                - quante crumb ha raccolto
             */
            
            let routeData = [
                "id" : self.route.id as Any,
                "latitude" : userLocation.coordinate.latitude,
                "longitude" : userLocation.coordinate.longitude,
                "collected" : self.actualCrumb
            ]
            db.child("Assisted").setValue(routeData)
            
            // Controllo se viene visualizzata la crumb, in caso contrario mostro le frecce
            DispatchQueue.main.async {
                self.getWhereIsLooking(sceneWidth: (self.sceneLocationView?.bounds.width)!, nodePosition: (self.sceneLocationView?.projectPoint(locationNodes[0].position))!)
            }
            
            print("DEBUG - Crumb at index \(self.actualCrumb) is \(Double(userLocation.distance(from: (locationNodes[0].location)!)).short) meters far away")
            
            if actualCrumb > 0 {
                // Calcolo la distanza tra la posizione attuale e il segmento che congiunge crumb[n] e crumb[n + 1]
                var distUserCrumbs = pointLineDistance(x1: prevCrumb.location.coordinate.longitude, y1: prevCrumb.location.coordinate.latitude, x2: locationNodes[0].location.coordinate.longitude, y2: locationNodes[0].location.coordinate.latitude, pointX: currentLocation.coordinate.longitude, pointY: currentLocation.coordinate.latitude)
                
                // Distanza calcolata in gradi, converto in metri
                distUserCrumbs = distUserCrumbs * 111111
                
                print("DEBUG - point-segment distance: \(distUserCrumbs)")
                
                // Se la distanza punto segmento è superiore ai 60 metri
                if distUserCrumbs > 60 {
                    // Riproduco l'audio 2 volte, dopo di che, in ARView, mostro il pop-up per chiamare il caregiver
                    if let audioSource = SCNAudioSource(fileNamed: "farFromCrumb.m4a") {
                        let audioPlayer = SCNAudioPlayer(source: audioSource)
                        
                        if !self.isPlaying && self.nPlays < 2 {
                            self.isPlaying = true
                            self.nPlays = self.nPlays + 1
                            self.sceneLocationView?.locationNodes[0].addAudioPlayer(audioPlayer)
                            audioPlayer.didFinishPlayback = {
                                self.sceneLocationView?.locationNodes[0].removeAudioPlayer(audioPlayer)
                                self.isPlaying = false
                            }
                        }
                    }
                    print("DEBUG - Far from trajectory")
                }
            }
            
            // Controllo se l'assistito è entro distanceThreshold metri dalla crumb visualizzata nella scena
            if !isColliding && Double(userLocation.distance(from: (locationNodes[0].location)!)) < distanceThreshold {
                self.isColliding = true
                
                // Salvo la crumb per caricare il prossimo segmento crumb[n] crumb[n + 1]
                prevCrumb = locationNodes[0]
                
                // Faccio vibrare il telefono
                UIDevice.vibrate()
                
                // Riproduco l'audio associato alla crumb
                if let audioSource = SCNAudioSource(fileNamed: (self.route.mapRoute.crumbs[actualCrumb].audio!.lastPathComponent)) {
                    let audioPlayer = SCNAudioPlayer(source: audioSource)
                    
                    self.sceneLocationView?.locationNodes[0].addAudioPlayer(audioPlayer)
                    audioPlayer.didFinishPlayback = {
                        self.sceneLocationView?.locationNodes[0].removeAudioPlayer(audioPlayer)
                        // Solo dopo aver riprodotto l'audio mostro la nuova crumb
                        self.actualCrumb = self.actualCrumb + 1
                        self.isColliding = false
                        self.addJustOneNode()
                    }
                }
            }
            renderTime = time + TimeInterval(0.75)
        }
    }
    
    public func renderer(_ renderer: SCNSceneRenderer, didApplyAnimationsAtTime time: TimeInterval) {
        
    }
    
    public func renderer(_ renderer: SCNSceneRenderer, didSimulatePhysicsAtTime time: TimeInterval) {
        
    }
    
    public func renderer(_ renderer: SCNSceneRenderer, didApplyConstraintsAtTime time: TimeInterval) {
        
    }
    
    public func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        
    }
    
    // Funzione di orientamento: se la crumb non viene inquadrata, l'assistito viene guidato nell'inquadrare nuovamente la crumb
    func getWhereIsLooking(sceneWidth: CGFloat, nodePosition: SCNVector3){
        if(nodePosition.z < 1){
            if(nodePosition.x > (Float(sceneWidth))){
                self.lookAt = 2
            }else if(nodePosition.x < 0){
                self.lookAt = 1
            }else{
                self.lookAt = 0
                return
            }
        }else if(nodePosition.x < 0){
            self.lookAt = 2
        }else{
            self.lookAt = 1
        }
    }
    
    // Funzione per il calcolo della distanza punto-segmento
    func pointLineDistance(x1: Double, y1: Double, x2: Double, y2: Double, pointX: Double, pointY: Double) -> Double {
        var diffX = x2 - x1;
        var diffY = y2 - y1;
        
        if ((diffX == 0) && (diffY == 0)) {
            diffX = pointX - x1;
            diffY = pointY - y1;
            return sqrt(diffX * diffX + diffY * diffY);
        }
        
        let t = ((pointX - x1) * diffX + (pointY - y1) * diffY) / (diffX * diffX + diffY * diffY);
        
        if (t < 0) {
            //point is nearest to the first point i.e x1 and y1
            diffX = pointX - x1;
            diffY = pointY - y1;
        } else if (t > 1) {
            //point is nearest to the end point i.e x2 and y2
            diffX = pointX - x2;
            diffY = pointY - y2;
        } else {
            //if perpendicular line intersect the line segment.
            diffX = pointX - (x1 + t * diffX);
            diffY = pointY - (y1 + t * diffY);
        }
        
        //returning shortest distance
        return sqrt(diffX * diffX + diffY * diffY);
    }
}

extension UIDevice {
    static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}
