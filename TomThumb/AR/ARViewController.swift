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
    var route = MapRoutesFactory().mapRoutes[1]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneLocationView.run()
        view.addSubview(sceneLocationView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        sceneLocationView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        for crumb in route.crumbs {
            let location = CLLocation(coordinate: crumb.location, altitude: 190)
            print("\(location.coordinate.latitude) \(location.coordinate.longitude)")
            let originalImage = UIImage(named: "mapPin")!
            let image = originalImage.resized(to: CGSize(width: 30, height: 30))
            
            let annotation = LocationAnnotationNode(location: location, image: image)

            sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotation)
        }
    }
    
    
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ARViewController>) -> ARViewController {
        return ARViewController()
    }
    
    func updateUIViewController(_ uiViewController: ARViewController.UIViewControllerType, context: UIViewControllerRepresentableContext<ARViewController>) {
        print("Update camera view")
    
    }
}

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}


struct ViewController_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
