//
//  MapViewAddRoute.swift
//  TomThumb
//
//  Created by Marco Ortu on 15/07/2020.
//  Copyright © 2020 Sora. All rights reserved.
//

import SwiftUI
import MapKit

var crumbs: [CLLocationCoordinate2D] = []

struct MapViewAddRoute: UIViewRepresentable {
    let locationManager = CLLocationManager()
    
    @Binding var pin: MapPin
    
    func makeCoordinator() -> MapViewAddRoute.Coordinator {
        return MapViewAddRoute.Coordinator(parent: self)
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
            let location: CLLocationCoordinate2D = locationManager.location!.coordinate
            let span = MKCoordinateSpan(latitudeDelta: 0.009, longitudeDelta: 0.009)
            let region = MKCoordinateRegion(center: location, span: span)
            mapView.setRegion(region, animated: true)
            mapView.mapType = .satellite
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            
            mapView.delegate = context.coordinator
            mapView.addAnnotation(annotation)
        }

        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {

    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapViewAddRoute
        
        init(parent: MapViewAddRoute) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            pin.isDraggable = true
            pin.pinTintColor = .blue
            pin.animatesDrop = true
            
            return pin
        }
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
            CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: (view.annotation?.coordinate.latitude)!, longitude: (view.annotation?.coordinate.longitude)!)) { (places, err) in
                self.parent.pin = MapPin(coordinate: CLLocationCoordinate2D(latitude: (view.annotation?.coordinate.latitude)!, longitude: (view.annotation?.coordinate.longitude)!), title: (places?.first?.name)!, subtitle: (places?.first?.locality)!)
            }
            crumbs.append(CLLocationCoordinate2D(latitude: (view.annotation?.coordinate.latitude)!, longitude: (view.annotation?.coordinate.longitude)!))
            print("-- CRUMBS --")
            print(crumbs)
            print("Size: \(crumbs.count)")
        }
    }
}

/*struct MapViewAddRoute_Previews: PreviewProvider {
    static var previews: some View {
        MapViewAddRoute()
    }
}*/
