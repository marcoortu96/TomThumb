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
        mapRoutes.append(MapRoute(start:CLLocationCoordinate2D(latitude: 39.306738158798424, longitude: 8.522636807002641), crumbs: [CLLocationCoordinate2D(latitude: 39.31039106615805, longitude: 8.524031271675483), CLLocationCoordinate2D(latitude: 39.31164794089193, longitude: 8.527542160533699)], finish: CLLocationCoordinate2D(latitude: 39.3124391731902, longitude:  8.532612347127468)))
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
