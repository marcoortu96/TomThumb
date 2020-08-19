//
//  LiveMapView.swift
//  TomThumb
//
//  Created by Andrea Re on 18/08/2020.
//  Copyright © 2020 Sora. All rights reserved.
//

import SwiftUI
import MapKit


struct LiveMapView: UIViewRepresentable {
    var mapRoute: MapRoute
    var annotations: [MKPointAnnotation]
    
    init(mapRoute: MapRoute, annotations: [MKPointAnnotation]) {
        self.mapRoute = mapRoute
        self.annotations = annotations
    }
    
    func makeCoordinator() -> LiveMapView.Coordinator {
        return LiveMapView.Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        //var annotations = [MKPointAnnotation]()
        
        /*if mapRoute.crumbs.count > 1 {
            let startAnnotation = MKPointAnnotation()
            startAnnotation.coordinate = mapRoute.crumbs[0].location.coordinate
            startAnnotation.title = "start"
            annotations.append(startAnnotation)
            
            let finishAnnotation = MKPointAnnotation()
            finishAnnotation.coordinate = mapRoute.crumbs[mapRoute.crumbs.count - 1].location.coordinate
            finishAnnotation.title = "finish"
            annotations.append(finishAnnotation)
            
            for (index,crumb) in mapRoute.crumbs[1..<(mapRoute.crumbs.count - 1)].enumerated() {
                let crumbAnnotation = MKPointAnnotation()
                crumbAnnotation.coordinate =  crumb.location.coordinate
                crumbAnnotation.title = String(index + 1)
                crumbAnnotation.subtitle = String("\(crumb.location)")
                annotations.append(crumbAnnotation)
            }
        }*/
        mapView.subviews[1].isHidden = true //hide 'legal' label from right-lower corner
        mapView.mapType = .hybrid
        mapView.delegate = context.coordinator
        mapView.showAnnotations(annotations, animated: true)
        
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        if annotations.count == view.annotations.count {
            view.removeAnnotations(view.annotations)
            view.addAnnotations(annotations)
        }
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: LiveMapView
        
        init(parent: LiveMapView) {
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


