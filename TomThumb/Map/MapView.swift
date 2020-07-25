//
//  MapViewAddRoute.swift
//  TomThumb
//
//  Created by Marco Ortu on 15/07/2020.
//  Copyright © 2020 Sora. All rights reserved.
//

import SwiftUI
import MapKit


struct MapView: UIViewRepresentable {
    var mapRoute: MapRoute
    
    init(mapRoute: MapRoute) {
        self.mapRoute = mapRoute
    }
    
    func makeCoordinator() -> MapView.Coordinator {
        return MapView.Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        var annotations = [MKPointAnnotation]()
        
        let startAnnotation = MKPointAnnotation()
        startAnnotation.coordinate = mapRoute.crumbs[0].location
        startAnnotation.title = "start"
        annotations.append(startAnnotation)
        
        let finishAnnotation = MKPointAnnotation()
        finishAnnotation.coordinate = mapRoute.crumbs[mapRoute.crumbs.count - 1].location
        finishAnnotation.title = "finish"
        annotations.append(finishAnnotation)
        
        for (index,crumb) in mapRoute.crumbs[1..<(mapRoute.crumbs.count - 1)].enumerated() {
            let crumbAnnotation = MKPointAnnotation()
            crumbAnnotation.coordinate = crumb.location
            crumbAnnotation.title = String(index + 1)
            crumbAnnotation.subtitle = String("\(crumb.location.latitude), \(crumb.location.longitude)")
            annotations.append(crumbAnnotation)
        }
        mapView.subviews[1].isHidden = true //hide 'legal' label from right-lower corner
        mapView.mapType = .hybrid
        mapView.delegate = context.coordinator
        mapView.showAnnotations(annotations, animated: true)
        
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        init(parent: MapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
            if annotation is MKUserLocation {
                return nil
            }
            
            let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            
            switch annotation.title! {
            case "start":
                annotationView.markerTintColor = InterfaceConstants.startPinColor
                annotationView.isEnabled = false
            case "finish":
                annotationView.markerTintColor = InterfaceConstants.finishPinColor
                annotationView.isEnabled = false
            default:
                annotationView.markerTintColor = InterfaceConstants.crumbPinColor
                annotationView.glyphImage = UIImage(systemName: "staroflife.fill")
                annotationView.isEnabled = true
            }
            
            annotationView.titleVisibility = MKFeatureVisibility.visible;
            annotationView.canShowCallout = true
            
            return annotationView
        }
        
    }
}

struct MapViewAddRoute_Previews: PreviewProvider {
    static var previews: some View {
        MapView(mapRoute: MapRoutesFactory().mapRoutes[0])
    }
}

