//
//  Route.swift
//  TomThumb
//
//  Created by Andrea Re on 13/07/2020.
//  Copyright © 2020 Sora. All rights reserved.
//

import Foundation

struct Route : Hashable {
    
    let id = UUID()
    var routeName: String
    var user: String
    var crumbs: Int
    var duration: TimeInterval
    var caregiver: Caregiver
    var mapRoute: MapRoute
    
    init(routeName: String, user: String, crumbs: Int, duration: TimeInterval, caregiver: Caregiver, mapRoute: MapRoute) {
        self.routeName = routeName
        self.user = user
        self.crumbs = crumbs
        self.duration = duration
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
