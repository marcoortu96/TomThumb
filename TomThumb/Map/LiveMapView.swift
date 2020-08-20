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
    @Binding var collected: Int
    
    init(route: Route, annotations: [MKPointAnnotation], collected: Binding<Int>) {
        self.route = route
        self.annotations = annotations
        self._collected = collected
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
                annotationView.markerTintColor = .gray
                if self.parent.collected >= 1 {
                    annotationView.markerTintColor = InterfaceConstants.startPinColor
                }
                annotationView.isEnabled = false
                annotationView.titleVisibility = MKFeatureVisibility.visible;
                annotationView.canShowCallout = true
                return annotationView
            case "finish":
                let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "pin")
                annotationView.markerTintColor = .gray
                if self.parent.collected == self.parent.route.crumbs {
                    annotationView.markerTintColor = InterfaceConstants.finishPinColor
                }
                annotationView.isEnabled = false
                annotationView.titleVisibility = MKFeatureVisibility.visible;
                annotationView.canShowCallout = true
                return annotationView
            default:
                if annotation.subtitle == "crumb" {
                    let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "pin")
                    annotationView.markerTintColor = .gray
                    let numTitle = Int(annotation.title!!)
                    if self.parent.collected > numTitle! {
                        annotationView.markerTintColor = InterfaceConstants.crumbPinColor
                    }
                    //annotationView.markerTintColor = InterfaceConstants.crumbPinColor
                    annotationView.glyphImage = UIImage(systemName: "staroflife.fill")
                    annotationView.isEnabled = false
                    annotationView.titleVisibility = MKFeatureVisibility.visible;
                    annotationView.canShowCallout = true
                    return annotationView
                } else {
                    let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "pin")
                    let image = UIImage(named: "dot")
                    annotationView.image = image?.resized(to: CGSize(width: 50, height: 50))
                    annotationView.isEnabled = true
                    return annotationView
                }
            }
        }
    }
}

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
