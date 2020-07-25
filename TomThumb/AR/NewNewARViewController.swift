//
//  NewNewARViewController.swift
//  TomThumb
//
//  Created by Marco Ortu on 24/07/2020.
//  Copyright © 2020 Sora. All rights reserved.
//

import Foundation
import ARCL
import ARKit
import MapKit
import SceneKit
import UIKit
import SwiftUI

//CLASSE INUTILIZZATA, USARE ARViewController
/*
// swiftlint:disable:next type_body_length
final class NewNewARViewController: UIViewController, UIViewControllerRepresentable {
    var sceneLocationView: SceneLocationView?
    /// This is for the `SceneLocationView`. There's no way to set a node's `locationEstimateMethod`, which is hardcoded to
    /// `mostRelevantEstimate`.
    public var locationEstimateMethod = LocationEstimateMethod.mostRelevantEstimate
    
    public var arTrackingType = SceneLocationView.ARTrackingType.orientationTracking
    public var scalingScheme = ScalingScheme.normal
    
    // These three properties are properties of individual nodes. We'll set them the same way for each node added.
    public var continuallyAdjustNodePositionWhenWithinRange = true
    public var continuallyUpdatePositionAndScale = true
    public var annotationHeightAdjustmentFactor = 1.1
    
    var route: MapRoute
    var actualCrumb: Int?
    @ObservedObject var locationManager = LocationManager()
    
    init(route: MapRoute) {
        self.route = route
        self.actualCrumb = 0
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle and actions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneLocationView = SceneLocationView()
        view.addSubview(sceneLocationView!)
        
    }
    
    func rebuildSceneLocationView() {
        sceneLocationView?.removeFromSuperview()
        let newSceneLocationView = SceneLocationView.init(trackingType: arTrackingType, frame: view.frame, options: nil)
        newSceneLocationView.translatesAutoresizingMaskIntoConstraints = false
        newSceneLocationView.arViewDelegate = self
        newSceneLocationView.locationEstimateMethod = locationEstimateMethod
        
        newSceneLocationView.debugOptions = [.showWorldOrigin]
        newSceneLocationView.showsStatistics = true
        newSceneLocationView.showAxesNode = false // don't need ARCL's axesNode because we're showing SceneKit's
        newSceneLocationView.autoenablesDefaultLighting = true
        view.addSubview(newSceneLocationView)
        sceneLocationView = newSceneLocationView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        rebuildSceneLocationView()
        addJustOneNode()
        //addStackOfNodes()
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
    
    // MARK: - Some canned demos
    
    /// Perform these actions on every node after it's added.
    func addScenewideNodeSettings(_ node: LocationNode) {
        if let annoNode = node as? LocationAnnotationNode {
            annoNode.annotationHeightAdjustmentFactor = annotationHeightAdjustmentFactor
        }
        node.scalingScheme = scalingScheme
        node.continuallyAdjustNodePositionWhenWithinRange = continuallyAdjustNodePositionWhenWithinRange
        node.continuallyUpdatePositionAndScale = continuallyUpdatePositionAndScale
    }
    
    /// Add one node, at our current location.
    // da adattare potrebbe essere utile
    func addJustOneNode() {
        guard (sceneLocationView?.sceneLocationManager.currentLocation) != nil else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.addJustOneNode()
            }
            return
        }
        
        sceneLocationView?.removeAllNodes()
        print("Crumb index: \(actualCrumb!), user altitude: \(self.locationManager.currentLocation!.altitude)")
        let location = CLLocation(coordinate: self.route.crumbs[actualCrumb!].location, altitude: self.locationManager.currentLocation!.altitude - 10)
        let cubeNode = LocationNode(location: location)
        let cubeSide = CGFloat(2)
        let cube = SCNBox(width: cubeSide, height: cubeSide, length: cubeSide, chamferRadius: 0)
        
        cube.firstMaterial?.diffuse.contents = UIColor.random
        cubeNode.addChildNode(SCNNode(geometry: cube))
        self.addScenewideNodeSettings(cubeNode)
        self.sceneLocationView?.addLocationNodeWithConfirmedLocation(locationNode: cubeNode)
    }
    
    // Add a stack of annotation nodes,
    func addStackOfNodes() {
        
        guard (self.locationManager.currentLocation) != nil else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.addStackOfNodes()
            }
            return
        }
        print("Reloading")
        
        let cubeSide = CGFloat(2)
        
        //Load crumbs
        for (index,crumb) in self.route.crumbs.enumerated() {
            let location = CLLocation(coordinate: crumb.location, altitude: self.locationManager.currentLocation!.altitude - 10)
            let cubeNode = LocationNode(location: location)
            let cube = SCNBox(width: cubeSide, height: cubeSide, length: cubeSide, chamferRadius: 0)
            
            cube.firstMaterial?.diffuse.contents = index == route.crumbs.count - 1 ? InterfaceConstants.finishPinColor : InterfaceConstants.crumbPinColor
            cubeNode.addChildNode(SCNNode(geometry: cube))
            self.addScenewideNodeSettings(cubeNode)
            self.sceneLocationView?.addLocationNodeWithConfirmedLocation(locationNode: cubeNode)
        }
        
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<NewNewARViewController>) -> NewNewARViewController {
        return NewNewARViewController(route: self.route)
    }
    
    func updateUIViewController(_ uiViewController: NewNewARViewController.UIViewControllerType, context: UIViewControllerRepresentableContext<NewNewARViewController>) {
        //print("Update camera view")
        
    }
}

// MARK: - ARSCNViewDelegate
extension NewNewARViewController: ARSCNViewDelegate {
    
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
    
    public func renderer(_ renderer: SCNSceneRenderer, didRenderScene scene: SCNScene, atTime time: TimeInterval) {
        //print(Double((self.locationManager.currentLocation?.distance(from: CLLocation(coordinate: self.route.crumbs[actualCrumb!].location, altitude: self.locationManager.currentLocation!.altitude)))!))
        if Double((self.locationManager.currentLocation?.distance(from: CLLocation(coordinate: self.route.crumbs[actualCrumb!].location, altitude: self.locationManager.currentLocation!.altitude)))!) < 10 {
            self.actualCrumb = self.actualCrumb! + 1
            if self.actualCrumb! < self.route.crumbs.count  {
                self.addJustOneNode()
            }
            else {
                print("Route completed! Good Job!")
            }
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
*/