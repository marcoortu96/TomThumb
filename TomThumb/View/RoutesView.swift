//
//  RoutesView.swift
//  TomThumb
//
//  Created by Andrea Re on 13/07/2020.
//  Copyright © 2020 Sora. All rights reserved.
//

import SwiftUI
import MapKit



struct RoutesView: View {
    @State private var searchText = ""
    @State var showAddRouteView = false
    @ObservedObject var routesFactory = RoutesFactory.getInstance()
    @State var audioRecorder = AudioRecorder()
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(searchText: $searchText)
                //print routes-list
                List(routesFactory.getRoutes().filter {
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
                        self.showAddRouteView.toggle()
                    }) {
                        Image(systemName: "plus.circle").font(.largeTitle)
                    }
            )
        }
        .accentColor(InterfaceConstants.genericLinkForegroundColor)
        .sheet(isPresented: $showAddRouteView) {
            //add new route view (load sheet)
            AddRouteView(showSheetView: self.$showAddRouteView, centerCoordinate: locationManager.location!.coordinate, audioRecorder: self.audioRecorder)
        }
    }
    
}


struct RoutesView_Previews: PreviewProvider {
    static var previews: some View {
        RoutesView()
    }
}

