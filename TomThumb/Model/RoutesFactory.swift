//
//  RoutesFactory.swift
//  TomThumb
//
//  Created by Andrea Re on 13/07/2020.
//  Copyright © 2020 Sora. All rights reserved.
//

import Foundation

struct RoutesFactory {
    
    var routes: [Route] = []
    
    init() {
        routes.append(Route(routeName: "Prima", user: "Filippo", crumbs: 10, duration: TimeInterval(1000), caregiver: Caregiver(name: "Mario", surname: "Rossi", cellphone: "+393383838383"), mapRoute: MapRoutesFactory().mapRoutes[0]))
        routes.append(Route(routeName: "Seconda", user: "Maria", crumbs: 10, duration: TimeInterval(1000),caregiver: Caregiver(name: "Carla", surname: "Verdi", cellphone: "+393383838383"), mapRoute: MapRoutesFactory().mapRoutes[1]))
        routes.append(Route(routeName: "Terza", user: "Andrea", crumbs: 10, duration: TimeInterval(1000),caregiver: Caregiver(name: "Luca", surname: "Bianchi", cellphone: "+393383838383"), mapRoute: MapRoutesFactory().mapRoutes[0]))
        routes.append(Route(routeName: "Quarta", user: "Elena", crumbs: 10, duration: TimeInterval(1000),caregiver: Caregiver(name: "Giuliano", surname: "Bastoni", cellphone: "+393383838383"), mapRoute: MapRoutesFactory().mapRoutes[2]))
        routes.append(Route(routeName: "Quinta", user: "Matteo", crumbs: 10, duration: TimeInterval(1000),caregiver: Caregiver(name: "Elisa", surname: "Neri", cellphone: "+393383838383"),
            mapRoute: MapRoutesFactory().mapRoutes[0]))
        routes.append(Route(routeName: "Sesta", user: "Ginevra", crumbs: 10, duration: TimeInterval(1000),caregiver: Caregiver(name: "Carlotta", surname: "Forse", cellphone: "+393383838383"), mapRoute: MapRoutesFactory().mapRoutes[2]))
        routes.append(Route(routeName: "Settima", user: "Alberto", crumbs: 10, duration: TimeInterval(1000), caregiver: Caregiver(name: "Mario", surname: "Mestolo", cellphone: "+393383838383"), mapRoute: MapRoutesFactory().mapRoutes[0]))
    }
    
}
