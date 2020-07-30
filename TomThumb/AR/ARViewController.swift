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

final class ARViewController: UIViewController, UIViewControllerRepresentable {
    var sceneLocationView: SceneLocationView?
    
    //This is for the `SceneLocationView`. There's no way to set a node's `locationEstimateMethod`, which is hardcoded to `mostRelevantEstimate`.
    public var locationEstimateMethod = LocationEstimateMethod.mostRelevantEstimate
    
    public var arTrackingType = SceneLocationView.ARTrackingType.worldTracking
    public var scalingScheme = ScalingScheme.normal
    
    // These three properties are properties of individual nodes. We'll set them the same way for each node added.
    public var continuallyAdjustNodePositionWhenWithinRange = true
    public var continuallyUpdatePositionAndScale = true
    public var annotationHeightAdjustmentFactor = -0.5
    
    public var renderTime: TimeInterval = 0
    private let distanceThreshold: Double = 5.0
    private var isColliding = false
    
    var route: MapRoute
    @Binding var actualCrumb: Int
    @Binding var lookAt: Int
    var locationManager = LocationManager()
    
    init(route: MapRoute, actualCrumb: Binding<Int>, lookAt: Binding<Int>) {
        self.route = route
        self._actualCrumb = actualCrumb
        self._lookAt = lookAt
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
        guard (self.actualCrumb < self.route.crumbs.count) else {
            print("DEBUG - Crumb index out of bounds, you might have finished the route!")
            viewWillDisappear(false)
            return
        }
        
        self.sceneLocationView?.removeAllNodes()
        
        let crumbNode = LocationNode(location: self.route.crumbs[self.actualCrumb].location)
        let crumbScene = SCNScene(named: "crumb.dae")
        guard let crumb: SCNNode = crumbScene?.rootNode.childNode(withName: "crumbModel", recursively: true) else {
            fatalError("crumbModel is not found")
        }
        
        if actualCrumb == 0 {
            crumb.geometry?.firstMaterial?.diffuse.contents = UIColor.systemRed
        } else if actualCrumb == (self.route.crumbs.count - 1) {
            crumb.geometry?.firstMaterial?.diffuse.contents = UIColor.systemGreen
        }
        
        crumbNode.addChildNode(crumb)
        crumbNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 120, z: 0, duration: 100)))
        //arrowNode.look(at: crumbNode.position)
        self.addScenewideNodeSettings(crumbNode)
        self.sceneLocationView?.addLocationNodeWithConfirmedLocation(locationNode: crumbNode)
    }
    
    // Add all crumbs at actual user altitude (- 5)
    func addStackOfNodes() {
        
        guard (self.locationManager.currentLocation) != nil else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.addStackOfNodes()
            }
            return
        }
        print("DEBUG - Reloading")
        
        let cubeSide = CGFloat(2)
        
        //Load crumbs
        for (index,crumb) in self.route.crumbs.enumerated() {
            let cubeNode = LocationNode(location: crumb.location)
            let cube = SCNBox(width: cubeSide, height: cubeSide, length: cubeSide, chamferRadius: 0)
            
            cube.firstMaterial?.diffuse.contents = index == route.crumbs.count - 1 ? InterfaceConstants.finishPinColor : InterfaceConstants.crumbPinColor
            cubeNode.addChildNode(SCNNode(geometry: cube))
            self.addScenewideNodeSettings(cubeNode)
            self.sceneLocationView?.addLocationNodeWithConfirmedLocation(locationNode: cubeNode)
        }
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ARViewController>) -> ARViewController {
        return ARViewController(route: self.route, actualCrumb: self.$actualCrumb, lookAt: self.$lookAt)
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
        
        guard actualCrumb < route.crumbs.count else { return }
        
        guard let currentLocation = self.sceneLocationView?.sceneLocationManager.currentLocation else { return }
        
        guard let locationNodes = sceneLocationView?.locationNodes else { return }
        
        guard locationNodes.count > 0 else { return }
        
        let userLocation = CLLocation(coordinate: currentLocation.coordinate,
                                      altitude: currentLocation.altitude)
        
        if time > renderTime {
            DispatchQueue.main.async {
                // UIView usage
                self.getWhereIsLooking(sceneWidth: (self.sceneLocationView?.bounds.width)!, nodePosition: (self.sceneLocationView?.projectPoint(locationNodes[0].position))!)
            }
            
            print("DEBUG - Crumb at index \(self.actualCrumb) is \(Double(userLocation.distance(from: (locationNodes[0].location)!)).short) meters far away")
            
            if !isColliding && Double(userLocation.distance(from: (locationNodes[0].location)!)) < distanceThreshold {
                self.isColliding = true
                
                if let audioSource = SCNAudioSource(fileNamed: (self.route.crumbs[actualCrumb].audio!.lastPathComponent)) {
                    let audioPlayer = SCNAudioPlayer(source: audioSource)
                    
                    self.sceneLocationView?.locationNodes[0].addAudioPlayer(audioPlayer)
                    audioPlayer.didFinishPlayback = {
                        self.sceneLocationView?.locationNodes[0].removeAudioPlayer(audioPlayer)
                        self.actualCrumb = self.actualCrumb + 1
                        self.isColliding = false
                        self.addJustOneNode()
                    }
                }
            }
            renderTime = time + TimeInterval(0.75)
        }
    }
    
    func getWhereIsLooking(sceneWidth: CGFloat, nodePosition: SCNVector3){
        if(nodePosition.z < 1){
            if(nodePosition.x > (Float(sceneWidth))){
                print("Look Right")
                self.lookAt = 2
            }else if(nodePosition.x < 0){
                print("Look Left")
                self.lookAt = 1
            }else{
                self.lookAt = 0
                return
            }
        }else if(nodePosition.x < 0){
            print("Look Right")
        }else{
            print("Look Left")
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
    
}
