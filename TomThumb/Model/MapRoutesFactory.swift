//
//  MapRoutesFactory.swift
//  TomThumb
//
//  Created by Andrea Re on 13/07/2020.
//  Copyright © 2020 Sora. All rights reserved.
//

import Foundation
import MapKit

struct MapRoute {
    var crumbs: [Crumb]
    
    init(crumbs: [Crumb]) {
        self.crumbs = crumbs
    }
    
}

struct MapRoutesFactory {
    var mapRoutes: [MapRoute] = []
    
    init() {
        
        mapRoutes.append(MapRoute(crumbs: [Crumb(location: CLLocationCoordinate2D(latitude: 39.306738158798424, longitude: 8.522636807002641), audio: URL(fileURLWithPath: Bundle.main.path(forResource: "start1.m4a", ofType: nil)!)), Crumb(location: CLLocationCoordinate2D(latitude: 39.31039106615805, longitude: 8.524031271675483), audio: URL(fileURLWithPath: Bundle.main.path(forResource: "crumb1.m4a", ofType: nil)!)), Crumb(location: CLLocationCoordinate2D(latitude: 39.31164794089193, longitude: 8.527542160533699), audio: URL(fileURLWithPath: Bundle.main.path(forResource: "crumb1.m4a", ofType: nil)!)), Crumb(location: CLLocationCoordinate2D(latitude: 39.3124391731902, longitude: 8.532612347127468), audio: URL(fileURLWithPath: Bundle.main.path(forResource: "finish1.m4a", ofType: nil)!))]))
        mapRoutes.append(MapRoute(crumbs: [Crumb(location: CLLocationCoordinate2D(latitude: 39.30628322407614, longitude: 8.52236695592103), audio: URL(fileURLWithPath: Bundle.main.path(forResource: "start1.m4a", ofType: nil)!)), Crumb(location: CLLocationCoordinate2D(latitude: 39.30622863914829, longitude: 8.522427422235353), audio: URL(fileURLWithPath: Bundle.main.path(forResource: "crumb1.m4a", ofType: nil)!)), Crumb(location: CLLocationCoordinate2D(latitude: 39.306148711123996, longitude: 8.522515602289701), audio: URL(fileURLWithPath: Bundle.main.path(forResource: "crumb1.m4a", ofType: nil)!)), Crumb(location: CLLocationCoordinate2D(latitude: 39.306076580873935, longitude: 8.522593704634005), audio: URL(fileURLWithPath: Bundle.main.path(forResource: "finish1.m4a", ofType: nil)!))]))
       
        //mapRoutes.append(MapRoute(start:CLLocationCoordinate2D(latitude: 49.306738158798424, longitude: 8.522636807002641), crumbs: [], finish: CLLocationCoordinate2D(latitude: 49.3124391731902, longitude:  8.532612347127468)))
        //mapRoutes.append(MapRoute(start:CLLocationCoordinate2D(latitude: 59.306738158798424, longitude: 8.522636807002641), crumbs: [], finish: CLLocationCoordinate2D(latitude: 59.3124391731902, longitude:  8.532612347127468)))
        
    }
}

extension CLLocationCoordinate2D {
    func distanceTo(coordinate: CLLocationCoordinate2D) -> CLLocationDistance {
        let thisLocation = CLLocation(latitude: self.latitude, longitude: self.longitude)
        let otherLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)

        return thisLocation.distance(from: otherLocation)
    }
}
