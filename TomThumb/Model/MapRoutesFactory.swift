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
    
    init() {
        self.crumbs = []
    }
    
    init(crumbs: [Crumb]) {
        self.crumbs = crumbs
    }
    
}

struct MapRoutesFactory {
    var mapRoutes: [MapRoute] = []
    
    init() {
        
        mapRoutes.append(MapRoute(crumbs: [Crumb(location: CLLocation(latitude: 39.306738158798424, longitude: 8.522636807002641), audio: URL(fileURLWithPath: Bundle.main.path(forResource: "start1.m4a", ofType: nil)!)), Crumb(location: CLLocation(latitude: 39.31039106615805, longitude: 8.524031271675483), audio: URL(fileURLWithPath: Bundle.main.path(forResource: "crumb1.m4a", ofType: nil)!)), Crumb(location: CLLocation(latitude: 39.31164794089193, longitude: 8.527542160533699), audio: URL(fileURLWithPath: Bundle.main.path(forResource: "crumb1.m4a", ofType: nil)!)), Crumb(location: CLLocation(latitude: 39.3124391731902, longitude: 8.532612347127468), audio: URL(fileURLWithPath: Bundle.main.path(forResource: "finish1.m4a", ofType: nil)!))]))
        mapRoutes.append(MapRoute(crumbs: [Crumb(location: CLLocation(latitude: 39.30628322407614, longitude: 8.52236695592103), audio: URL(fileURLWithPath: Bundle.main.path(forResource: "start1.m4a", ofType: nil)!)), Crumb(location: CLLocation(latitude: 39.30622863914829, longitude: 8.522427422235353), audio: URL(fileURLWithPath: Bundle.main.path(forResource: "crumb1.m4a", ofType: nil)!)), Crumb(location: CLLocation(latitude: 39.306148711123996, longitude: 8.522515602289701), audio: URL(fileURLWithPath: Bundle.main.path(forResource: "crumb1.m4a", ofType: nil)!)), Crumb(location: CLLocation(latitude: 39.306076580873935, longitude: 8.522593704634005), audio: URL(fileURLWithPath: Bundle.main.path(forResource: "finish1.m4a", ofType: nil)!))]))
        mapRoutes.append(MapRoute(crumbs: [Crumb(location: CLLocation(latitude: 39.30660030063669, longitude: 8.522361299008622), audio: URL(fileURLWithPath: Bundle.main.path(forResource: "start1.m4a", ofType: nil)!)), Crumb(location: CLLocation(latitude: 39.306565961295746, longitude: 8.52255673148747), audio: URL(fileURLWithPath: Bundle.main.path(forResource: "crumb1.m4a", ofType: nil)!)), Crumb(location: CLLocation(latitude: 39.306626790537905, longitude: 8.522722695137446), audio: URL(fileURLWithPath: Bundle.main.path(forResource: "crumb1.m4a", ofType: nil)!)), Crumb(location: CLLocation(latitude: 39.30677132383582, longitude: 8.522752390814674), audio: URL(fileURLWithPath: Bundle.main.path(forResource: "finish1.m4a", ofType: nil)!))]))
        
    }
}
