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
    let locationManager = CLLocationManager()
    
    var mapRoute: MapRoute
    
    init(mapRoute: MapRoute) {
        self.mapRoute = mapRoute
    }
    
    func makeCoordinator() -> MapView.Coordinator {
        return MapView.Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        var annotations = [MKPointAnnotation]()
        let status = CLLocationManager.authorizationStatus()
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            
            let startAnnotation = MKPointAnnotation()
            startAnnotation.coordinate = mapRoute.start.location
            startAnnotation.title = "start"
            annotations.append(startAnnotation)
            
            let finishAnnotation = MKPointAnnotation()
            finishAnnotation.coordinate = mapRoute.finish.location
            finishAnnotation.title = "finish"
            annotations.append(finishAnnotation)
           
            for (index,crumb) in mapRoute.crumbs.enumerated() {
                let crumbAnnotation = MKPointAnnotation()
                crumbAnnotation.coordinate = crumb.location
                crumbAnnotation.title = String(index + 1)
                crumbAnnotation.subtitle = String("\(crumb.location.latitude), \(crumb.location.longitude)")
                annotations.append(crumbAnnotation)
            }
            
            mapView.mapType = .hybrid
            mapView.delegate = context.coordinator
            mapView.showAnnotations(annotations, animated: true)
        }
        
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

/*struct MapViewAddRoute_Previews: PreviewProvider {
 static var previews: some View {
 MapViewAddRoute()
 }
 }*/
