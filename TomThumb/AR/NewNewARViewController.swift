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
    @ObservedObject var locationManager = LocationManager()
    
    init(route: MapRoute) {
        self.route = route
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle and actions

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Init sceneLocationView")
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
        //addJustOneNode()
        addStackOfNodes()
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
        guard let currentLocation = sceneLocationView?.sceneLocationManager.currentLocation else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.addJustOneNode()
            }
            return
        }

        // Copy the current location because it's a reference type. Necessary?
        let referenceLocation = CLLocation(coordinate: currentLocation.coordinate,
                                           altitude: currentLocation.altitude)
        let startingPoint = CLLocation(coordinate: referenceLocation.coordinate, altitude: referenceLocation.altitude)
        let originNode = LocationNode(location: startingPoint)
        let pyramid: SCNPyramid = SCNPyramid(width: 1.0, height: 1.0, length: 1.0)
        pyramid.firstMaterial?.diffuse.contents = UIColor.systemPink
        let pyramidNode = SCNNode(geometry: pyramid)
        originNode.addChildNode(pyramidNode)
        addScenewideNodeSettings(originNode)
        sceneLocationView?.addLocationNodeWithConfirmedLocation(locationNode: originNode)
    }

    // Add a stack of annotation nodes,
    func addStackOfNodes() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            print("Altitude \(self.locationManager.currentLocation!.altitude)")
            var location = CLLocation(coordinate: self.route.start.location, altitude: self.locationManager.currentLocation!.altitude - 10)
                        // Now create a plain old geometry node at the same location.
            
            // Start crumb
            var cubeNode = LocationNode(location: location)
            var cubeSide = CGFloat(5)
            var cube = SCNBox(width: cubeSide, height: cubeSide, length: cubeSide, chamferRadius: 0)
            cube.firstMaterial?.diffuse.contents = UIColor.systemGreen
            cubeNode.addChildNode(SCNNode(geometry: cube))
            self.addScenewideNodeSettings(cubeNode)
            self.sceneLocationView?.addLocationNodeWithConfirmedLocation(locationNode: cubeNode)
            
            //Load crumbs
            for (_,crumb) in self.route.crumbs.enumerated() {
                location = CLLocation(coordinate: crumb.location, altitude: self.locationManager.currentLocation!.altitude - 10)
                
                    cubeNode = LocationNode(location: location)
                    cubeSide = CGFloat(5)
                    cube = SCNBox(width: cubeSide, height: cubeSide, length: cubeSide, chamferRadius: 0)
                    cube.firstMaterial?.diffuse.contents = UIColor.systemBlue
                    cubeNode.addChildNode(SCNNode(geometry: cube))
                    self.addScenewideNodeSettings(cubeNode)
                self.sceneLocationView?.addLocationNodeWithConfirmedLocation(locationNode: cubeNode)
            }
            
            //Finish crumb
            location = CLLocation(coordinate: self.route.finish.location, altitude: self.locationManager.currentLocation!.altitude - 10)
            cubeNode = LocationNode(location: location)
            cubeSide = CGFloat(5)
            cube = SCNBox(width: cubeSide, height: cubeSide, length: cubeSide, chamferRadius: 0)
            cube.firstMaterial?.diffuse.contents = UIColor.systemRed
            cubeNode.addChildNode(SCNNode(geometry: cube))
            self.addScenewideNodeSettings(cubeNode)
            self.sceneLocationView?.addLocationNodeWithConfirmedLocation(locationNode: cubeNode)
        }
        
    }

    /// Create a `LocationAnnotationNode` at `altitude` meters above the given location, labeled with the altitude.
    func buildDisplacedAnnotationViewNode(altitude: Double, color: UIColor, location: CLLocation) -> LocationAnnotationNode {
        let labeledView = UIView.prettyLabeledView(text: "\(altitude)", backgroundColor: color)
        let result = LocationAnnotationNode(location: location, view: labeledView)
        return result
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
        DispatchQueue.main.async {
            print("Replace code here")
        }
    }

    public func renderer(_ renderer: SCNSceneRenderer, didApplyAnimationsAtTime time: TimeInterval) {
        // print(#file, #function)
    }

    public func renderer(_ renderer: SCNSceneRenderer, didSimulatePhysicsAtTime time: TimeInterval) {
        // print(#file, #function)
    }

    public func renderer(_ renderer: SCNSceneRenderer, didApplyConstraintsAtTime time: TimeInterval) {
        // print(#file, #function)
    }

    public func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        // print(#file, #function)
    }
    

}

extension UIView {
    /// Create a colored view with label, border, and rounded corners.
    class func prettyLabeledView(text: String,
                                 backgroundColor: UIColor = .systemBackground,
                                 borderColor: UIColor = .black) -> UIView {
        let font = UIFont.preferredFont(forTextStyle: .title2)
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = (text as NSString).size(withAttributes: fontAttributes)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))

        let attributedString = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: font])
        label.attributedText = attributedString
        label.textAlignment = .center
        label.adjustsFontForContentSizeCategory = true

        let cframe = CGRect(x: 0, y: 0, width: label.frame.width + 20, height: label.frame.height + 10)
        let cview = UIView(frame: cframe)
        cview.translatesAutoresizingMaskIntoConstraints = false
        cview.layer.cornerRadius = 10
        cview.layer.backgroundColor = backgroundColor.cgColor
        cview.layer.borderColor = borderColor.cgColor
        cview.layer.borderWidth = 1
        cview.addSubview(label)
        label.center = cview.center

        return cview
    }

}
