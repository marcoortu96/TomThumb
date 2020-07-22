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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        sceneLocationView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Start crumb
        var location = CLLocation(coordinate: route.start.location, altitude: 190)
        let originalImage = UIImage(named: "mapPin")!
        let image = originalImage.resized(to: CGSize(width: 30, height: 30))
        var annotation = LocationAnnotationNode(location: location, image: image)
        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotation)
        
        //Load crumbs
        for crumb in route.crumbs {
            location = CLLocation(coordinate: crumb.location, altitude: 190)
            
            annotation = LocationAnnotationNode(location: location, image: image)
            
            sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotation)
        }
        
        //Finish crumb
        location = CLLocation(coordinate: route.finish.location, altitude: 190)
        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotation)
        
    }
    
    
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ARViewController>) -> ARViewController {
        
        return ARViewController(route: self.route)
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
