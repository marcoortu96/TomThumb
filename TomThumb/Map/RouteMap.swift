//
//  RouteMap.swift
//  TomThumb
//
//  Created by Andrea Re on 13/07/2020.
//  Copyright © 2020 Sora. All rights reserved.
//

import SwiftUI
import MapKit

struct RouteMap: View {
    var mapRoute: MapRoute
    @ObservedObject var locationViewModel = LocationManager()
    
    var body: some View {
        ZStack {
            MapView(mapRoute: mapRoute)
            HStack() {
                Text("Latitude: \(self.locationViewModel.userLatitude)")
                Text("Longitude: \(self.locationViewModel.userLongitude)")
            }
            .background(Color.black)
            .foregroundColor(.white)
            .padding(.top, (UIScreen.main.bounds.size.height/100) * 70)
        }
    }
}

struct RouteMap_Previews: PreviewProvider {
    static var previews: some View {
        RouteMap(mapRoute: MapRoute(start:CLLocationCoordinate2D(latitude: 39.306738158798424, longitude: 8.522636807002641), crumbs: [], finish: CLLocationCoordinate2D(latitude: 39.3124391731902, longitude:  8.532612347127468)))
    }
}
