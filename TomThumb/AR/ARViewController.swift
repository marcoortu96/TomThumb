//
//  ARViewController.swift
//  TomThumb
//
//  Created by Andrea Re on 13/07/2020.
//  Copyright © 2020 Sora. All rights reserved.
//

import Foundation
import CoreLocation
import ARCL
import UIKit
import SwiftUI

final class ARViewController: UIViewController, UIViewControllerRepresentable {
    var sceneLocationView = SceneLocationView()
    @ObservedObject var locationManager = LocationManager()
    var route: MapRoute
    
    init(route: MapRoute) {
        self.route = route
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneLocationView.run()
        view.addSubview(sceneLocationView)
        
        setupScene()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        sceneLocationView.frame = view.bounds
    }
    
    func setupScene() {
        let startImage = UIImage(named: "startPin")!.resized(to: CGSize(width: 30, height: 30))
        let crumbImage = UIImage(named: "crumbPin")!.resized(to: CGSize(width: 30, height: 30))
        let finishImage = UIImage(named: "finishPin")!.resized(to: CGSize(width: 30, height: 30))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            print("Altitude \(self.locationManager.currentLocation!.altitude)")
            var location = CLLocation(coordinate: self.route.start.location, altitude: self.locationManager.currentLocation!.altitude - 10)
            var annotationNode = LocationAnnotationNode(location: location, image: startImage)
            annotationNode.annotationNode.name = "Start"
            self.sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
            
            //Load crumbs
            for (index,crumb) in self.route.crumbs.enumerated() {
                location = CLLocation(coordinate: crumb.location, altitude: self.locationManager.currentLocation!.altitude - 10)
                
                
                annotationNode = LocationAnnotationNode(location: location, image: crumbImage)
                annotationNode.annotationNode.name = "Crumb\(index + 1)"
                
                self.sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
            }
            
            //Finish crumb
            location = CLLocation(coordinate: self.route.finish.location, altitude: self.locationManager.currentLocation!.altitude - 10)
            annotationNode = LocationAnnotationNode(location: location, image: finishImage)
            annotationNode.annotationNode.name = "Finish"
            self.sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: sceneLocationView)
            
            let hitResults = sceneLocationView.hitTest(touchLocation, options: [.boundingBoxOnly : true])
            for result in hitResults {
                print("HIT:-> Name: \(result.node.description)")
            }
        }
    }
    
    
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ARViewController>) -> ARViewController {
        
        return ARViewController(route: self.route)
    }
    
    func updateUIViewController(_ uiViewController: ARViewController.UIViewControllerType, context: UIViewControllerRepresentableContext<ARViewController>) {
        //print("Update camera view")
        
    }
}

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

/*
 struct ViewController_Previews: PreviewProvider {
 static var previews: some View {
 /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
 }
 }
 */
