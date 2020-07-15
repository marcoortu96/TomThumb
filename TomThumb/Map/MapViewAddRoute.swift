//
//  MapViewAddRoute.swift
//  TomThumb
//
//  Created by Marco Ortu on 15/07/2020.
//  Copyright © 2020 Sora. All rights reserved.
//

import SwiftUI
import MapKit

struct MapViewAddRoute: UIViewRepresentable {
    let locationManager = CLLocationManager()
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)

        return mapView
    }
    func updateUIView(_ view: MKMapView, context: Context) {

        let status = CLLocationManager.authorizationStatus()
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            let location: CLLocationCoordinate2D = locationManager.location!.coordinate
            let span = MKCoordinateSpan(latitudeDelta: 0.009, longitudeDelta: 0.009)
            let region = MKCoordinateRegion(center: location, span: span)
            view.setRegion(region, animated: true)
            view.mapType = .satellite
        }
    }
}

struct MapViewAddRoute_Previews: PreviewProvider {
    static var previews: some View {
        MapViewAddRoute()
    }
}
