//
//  Route.swift
//  TomThumb
//
//  Created by Andrea Re on 13/07/2020.
//  Copyright © 2020 Sora. All rights reserved.
//

import Foundation
import MapKit

struct Route : Hashable {
    
    let id = UUID()
    var routeName: String
    var user: String
    var crumbs: Int
    var distance: Double
    var caregiver: Caregiver
    var mapRoute: MapRoute
    
    init(routeName: String, user: String, caregiver: Caregiver, mapRoute: MapRoute) {
        self.routeName = routeName
        self.user = user
        self.crumbs = mapRoute.crumbs.count
        
        var totalDistance = 0.0
        totalDistance = mapRoute.start.distanceTo(coordinate: mapRoute.crumbs[0])
        if routeName == "Prima" {
            print(totalDistance)
        }
        for i in stride(from: 0, to: mapRoute.crumbs.count - 1, by: 1) {
            totalDistance = totalDistance + mapRoute.crumbs[i].distanceTo(coordinate: mapRoute.crumbs[i + 1])
            if routeName == "Prima" {
                print(totalDistance)
            }
        }
        totalDistance = totalDistance + mapRoute.crumbs[mapRoute.crumbs.count - 1].distanceTo(coordinate: mapRoute.finish)
        if routeName == "Prima" {
            print(totalDistance)
        }
        self.distance = totalDistance
        self.caregiver = caregiver
        self.mapRoute = mapRoute
    }
    
    static func == (lhs: Route, rhs: Route) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}
