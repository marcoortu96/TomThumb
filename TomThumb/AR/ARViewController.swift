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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneLocationView.run()
        
        let coordinate1 = CLLocationCoordinate2D(latitude: 39.30359922336609, longitude: 8.525136433515627)
        let location1 = CLLocation(coordinate: coordinate1, altitude: 202)
        
        let coordinate2 = CLLocationCoordinate2D(latitude: 39.30269757899353, longitude: 8.522419064225488)
        let location2 = CLLocation(coordinate: coordinate2, altitude: 202)
        let image = UIImage(systemName: "play.fill")!

        let annotationNode1 = LocationAnnotationNode(location: location1, image: image)
        let annotationNode2 = LocationAnnotationNode(location: location2, image: image)
               
        
        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode1)
        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode2)
        
        view.addSubview(sceneLocationView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        sceneLocationView.frame = view.bounds
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ARViewController>) -> ARViewController {
        return ARViewController()
    }
    
    func updateUIViewController(_ uiViewController: ARViewController.UIViewControllerType, context: UIViewControllerRepresentableContext<ARViewController>) {
        print("Update camera view")
    }
    
}


struct ViewController_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
