//
//  RoutesView.swift
//  TomThumb
//
//  Created by Andrea Re on 13/07/2020.
//  Copyright © 2020 Sora. All rights reserved.
//

import SwiftUI
import MapKit

var routes = RoutesFactory().routes

struct RoutesView: View {
    @State private var searchText = ""
    @State var showAddRouteView = false
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(searchText: $searchText)
                List(routes.filter {
                    self.searchText == "" ? true : $0.routeName.localizedCaseInsensitiveContains(searchText)
                    }, id: \.self)
                { route in
                    NavigationLink(destination: RouteDetail(route: route)) {
                        Text(route.routeName)
                    }
                }
                
            }.navigationBarTitle("Percorsi")
             .navigationBarItems(trailing:
                 Button(action: {
                    print("add icon pressed...")
                    self.showAddRouteView.toggle()
                    
                 }) {
                    Image(systemName: "plus.circle").font(.largeTitle)
                 }
             )
        }
        .accentColor(InterfaceConstants.genericlinkForegroundColor)
        .sheet(isPresented: $showAddRouteView) {
            AddRouteView(showSheetView: self.$showAddRouteView, centerCoordinate: locationManager.location!.coordinate)
        }
    }
    
}


struct RoutesView_Previews: PreviewProvider {
    static var previews: some View {
        RoutesView()
    }
}

