//
//  MapView.swift
//  TomThumb
//
//  Created by Andrea Re on 13/07/2020.
//  Copyright © 2020 Sora. All rights reserved.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    var mapRoute: MapRoute
    
    init(mapRoute: MapRoute) {
        self.mapRoute = mapRoute
    }
    
    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
        MKMapView()
    }
    
    func updateUIView(_ uiView: MapView.UIViewType, context: UIViewRepresentableContext<MapView>) {
        
        var pins: [MapPin] = []
        pins.append(MapPin(coordinate: mapRoute.start, title: "Start", subtitle: ""))
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let region = MKCoordinateRegion(center: mapRoute.start, span: span)
        
        for crumb in mapRoute.crumbs {
            pins.append(MapPin(coordinate: crumb, title: "", subtitle: ""))
        }
        
        pins.append(MapPin(coordinate: mapRoute.finish, title: "Finish", subtitle: ""))
        
        uiView.setRegion(region, animated: true)
        uiView.addAnnotations(pins)
        uiView.showsCompass = true
        uiView.showsUserLocation = true
        
    }
    
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(mapRoute: MapRoute(start:CLLocationCoordinate2D(latitude: 39.306738158798424, longitude: 8.522636807002641), crumbs: [], finish: CLLocationCoordinate2D(latitude: 39.3124391731902, longitude:  8.532612347127468)))
    }
}
