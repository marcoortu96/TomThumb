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
    @State var crumbAudio = URL(fileURLWithPath: "")
    @State var currentCrumb = Crumb(location: CLLocation())
    @State var crumbs = [Crumb]()
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(searchText: $searchText)
                List {
                    ForEach(routesFactory.getRoutes().filter {
                    self.searchText == "" ? true : $0.routeName.localizedCaseInsensitiveContains(searchText)
                    }, id: \.self) { route in
                        NavigationLink(destination: RouteDetail(route: route)) {
                              Text("\(route.routeName)")
                        }
                    }
                    .onDelete(perform: deleteRoute)
                }
            }
            .navigationBarTitle("Percorsi")
            .navigationBarItems(leading: EditButton(), trailing:
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
            AddRouteView(showSheetView: self.$showAddRouteView, centerCoordinate: locationManager.location!.coordinate, audioRecorder: self.audioRecorder, crumbAudio: self.crumbAudio, currentCrumb: self.currentCrumb, crumbs: self.crumbs)
        }
    }
    
    func deleteRoute(at offsets: IndexSet) {
        RoutesFactory.remove(index: offsets)
        print(RoutesFactory.getInstance().getRoutes()[0].routeName)
    }
    
}


/*struct RoutesView_Previews: PreviewProvider {
    static var previews: some View {
        RoutesView()
    }
}*/

