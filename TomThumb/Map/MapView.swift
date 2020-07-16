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
        
        let status = CLLocationManager.authorizationStatus()
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        //Control if user authorized his position
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            
            let startAnnotation = MKPointAnnotation()
            startAnnotation.coordinate = mapRoute.start
            startAnnotation.title = "start"
            mapView.addAnnotation(startAnnotation)
            
            let finishAnnotation = MKPointAnnotation()
            finishAnnotation.coordinate = mapRoute.finish
            finishAnnotation.title = "finish"
            mapView.addAnnotation(finishAnnotation)
            
            for crumb in mapRoute.crumbs {
                let crumbAnnotation = MKPointAnnotation()
                crumbAnnotation.coordinate = crumb
                mapView.addAnnotation(crumbAnnotation)
            }
            
            let span = MKCoordinateSpan(latitudeDelta: 0.09, longitudeDelta: 0.09)
            let region = MKCoordinateRegion(center: mapRoute.crumbs[mapRoute.crumbs.capacity/2], span: span)
            mapView.setRegion(region, animated: true)
            mapView.mapType = .hybrid
            mapView.delegate = context.coordinator
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
                annotationView.titleVisibility = MKFeatureVisibility.visible;
                annotationView.canShowCallout = true
            case "finish":
                annotationView.markerTintColor = InterfaceConstants.finishPinColor
                annotationView.titleVisibility = MKFeatureVisibility.visible;
                annotationView.canShowCallout = true
            default:
                annotationView.markerTintColor = InterfaceConstants.crumbPinColor
            }
            
            annotationView.isEnabled = false
            
            return annotationView
        }
        
    }
}

/*struct MapViewAddRoute_Previews: PreviewProvider {
 static var previews: some View {
 MapViewAddRoute()
 }
 }*/
