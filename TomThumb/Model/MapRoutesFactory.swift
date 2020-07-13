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
    var start: CLLocationCoordinate2D
    var crumbs: [CLLocationCoordinate2D]
    var finish: CLLocationCoordinate2D
    
    init(start: CLLocationCoordinate2D, crumbs: [CLLocationCoordinate2D], finish: CLLocationCoordinate2D) {
        self.start = start
        self.crumbs = crumbs
        self.finish = finish
    }
    
}

struct MapRoutesFactory {
    var mapRoutes: [MapRoute] = []
    
    init() {
        mapRoutes.append(MapRoute(start:CLLocationCoordinate2D(latitude: 39.306738158798424, longitude: 8.522636807002641), crumbs: [], finish: CLLocationCoordinate2D(latitude: 39.3124391731902, longitude:  8.532612347127468)))
        mapRoutes.append(MapRoute(start:CLLocationCoordinate2D(latitude: 49.306738158798424, longitude: 8.522636807002641), crumbs: [], finish: CLLocationCoordinate2D(latitude: 49.3124391731902, longitude:  8.532612347127468)))
        mapRoutes.append(MapRoute(start:CLLocationCoordinate2D(latitude: 59.306738158798424, longitude: 8.522636807002641), crumbs: [], finish: CLLocationCoordinate2D(latitude: 59.3124391731902, longitude:  8.532612347127468)))
        
    }
}
