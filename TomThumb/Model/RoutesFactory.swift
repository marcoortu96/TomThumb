//
//  RoutesFactory.swift
//  TomThumb
//
//  Created by Andrea Re on 13/07/2020.
//  Copyright © 2020 Sora. All rights reserved.
//

import Foundation
import MapKit

class Route : Hashable, ObservableObject {
    let id = UUID()
    var routeName: String
    var user: String
    var crumbs: Int
    var distance: Double
    var caregiver: Caregiver
    var mapRoute: MapRoute
    
    init() {
        self.routeName = ""
        self.user = ""
        self.crumbs = 0
        self.distance = 0.0
        self.caregiver = CaregiverFactory().caregivers[0]
        self.mapRoute = MapRoutesFactory().mapRoutes[0]
    }
    
    init(routeName: String, user: String, caregiver: Caregiver, mapRoute: MapRoute) {
        self.routeName = routeName
        self.user = user
        self.crumbs = mapRoute.crumbs.count
        
        var totalDistance = 0.0
        for i in stride(from: 0, to: mapRoute.crumbs.count - 1, by: 1) {
            totalDistance = totalDistance + mapRoute.crumbs[i].location.distance(from: mapRoute.crumbs[i + 1].location)
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


class RoutesFactory: ObservableObject {
    
    private static var instance : RoutesFactory?
    @Published var routes: [Route]! = []
    
    init() {
        routes.append(Route(routeName: "Prima", user: "Filippo",
                            caregiver: CaregiverFactory().caregivers[0],
                            mapRoute: MapRoutesFactory().mapRoutes[0]))
        routes.append(Route(routeName: "Seconda", user: "Andrea",
                            caregiver: CaregiverFactory().caregivers[0],
                            mapRoute: MapRoutesFactory().mapRoutes[1]))
        routes.append(Route(routeName: "Terza", user: "Matteo",
                            caregiver: CaregiverFactory().caregivers[0],
                            mapRoute: MapRoutesFactory().mapRoutes[2]))
        routes.append(Route(routeName: "Quarta", user: "Alberto",
                            caregiver: CaregiverFactory().caregivers[0],
                            mapRoute: MapRoutesFactory().mapRoutes[1]))
    }
    
    public static func getInstance() -> RoutesFactory {
        if (RoutesFactory.instance == nil) {
            RoutesFactory.instance = RoutesFactory()
        }
        return RoutesFactory.instance!
    }
    
    public func getRoutes() -> [Route] {
        return routes!
    }
    
    public func setRoutes(routes : [Route]) {
        self.routes = routes
    }
    
    public static func insertRoute(route : Route) {
        var routes = RoutesFactory.getInstance().getRoutes()
        routes.append(route)
        RoutesFactory.getInstance().setRoutes(routes: routes)
    }
    
    public static func remove(index: IndexSet) {
        var routes = RoutesFactory.getInstance().getRoutes()
        routes.remove(atOffsets: index)
        RoutesFactory.getInstance().setRoutes(routes: routes)
    }
    
}
