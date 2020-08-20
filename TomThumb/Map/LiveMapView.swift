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
            
            switch annotation.title! {
            case "start":
                let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "pin")
                annotationView.markerTintColor = InterfaceConstants.startPinColor
                annotationView.isEnabled = false
                annotationView.titleVisibility = MKFeatureVisibility.visible;
                annotationView.canShowCallout = true
                return annotationView
            case "finish":
                let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "pin")
                annotationView.markerTintColor = InterfaceConstants.finishPinColor
                annotationView.isEnabled = false
                annotationView.titleVisibility = MKFeatureVisibility.visible;
                annotationView.canShowCallout = true
                return annotationView
            default:
                if annotation.subtitle == "crumb" {
                    let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "pin")
                    annotationView.markerTintColor = InterfaceConstants.crumbPinColor
                    annotationView.glyphImage = UIImage(systemName: "staroflife.fill")
                    annotationView.isEnabled = false
                    annotationView.titleVisibility = MKFeatureVisibility.visible;
                    annotationView.canShowCallout = true
                    return annotationView
                } else {
                    let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "pin")
                    annotationView.image = UIImage(named: "dot")
                    annotationView.isEnabled = true
                    return annotationView
                }
            }
        }
    }
}


