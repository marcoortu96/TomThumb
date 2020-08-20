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
    var route: Route
    var annotations: [MKPointAnnotation]
    var collected: Int
    
    init(route: Route, annotations: [MKPointAnnotation], collected: Int) {
        self.route = route
        self.annotations = annotations
        self.collected = collected
    }
    
    func makeCoordinator() -> LiveMapView.Coordinator {
        return LiveMapView.Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.subviews[1].isHidden = true //hide 'legal' label from right-lower corner
        mapView.mapType = .hybrid
        mapView.delegate = context.coordinator
        mapView.showAnnotations(annotations, animated: true)
        
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        if annotations.count == view.annotations.count {
            //view.annotations.dropLast()
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
                if annotation.subtitle == "crumb" {
                    annotationView.markerTintColor = InterfaceConstants.crumbPinColor
                    annotationView.glyphImage = UIImage(systemName: "staroflife.fill")
                    annotationView.isEnabled = false
                } else {
                    annotationView.markerTintColor = .orange
                    annotationView.glyphImage = UIImage(systemName: "person.circle.fill")
                    annotationView.isEnabled = true
                }
            
            }
            
            annotationView.titleVisibility = MKFeatureVisibility.visible;
            annotationView.canShowCallout = true
            
            return annotationView
        }
        
    }
}


