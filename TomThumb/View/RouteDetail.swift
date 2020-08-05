//
//  RouteDetail.swift
//  TomThumb
//
//  Created by Andrea Re on 13/07/2020.
//  Copyright © 2020 Sora. All rights reserved.
//

import SwiftUI
import MapKit
import UIKit

struct RouteDetail: View {
    @ObservedObject var route: Route
    
    var body: some View {
        Form {
            Section(header: Text("Nome")) {
                NavigationLink(destination: ChangeRouteName(route: route)) {
                    VStack {
                        Text(route.routeName)
                    }
                }
            }
            Section(header: Text("Dettagli")) {
                HStack {
                    Text("Inizio")
                    Spacer()
                    Text("\(route.startName)").foregroundColor(InterfaceConstants.secondaryInfoForegroundColor)
                }
                HStack {
                    Text("Fine")
                    Spacer()
                    Text("\(route.finishName)").foregroundColor(InterfaceConstants.secondaryInfoForegroundColor)
                }
                HStack {
                    Text("#Molliche")
                    Spacer()
                    Text("\(route.crumbs)").foregroundColor(InterfaceConstants.secondaryInfoForegroundColor)
                }
                HStack {
                    Text("Distanza")
                    Spacer()
                    Text("\(route.distance.short)m").foregroundColor(InterfaceConstants.secondaryInfoForegroundColor)
                }
            }
            Section(header: Text("Mappa")) {
                NavigationLink(destination: MapView(mapRoute: route.mapRoute)) {
                    Text("Visualizza il percorso")
                }.accentColor(InterfaceConstants.genericLinkForegroundColor)
            }
            Section(header: Text("Prova")) {
                NavigationLink(destination: ARView(route: route.mapRoute, debug: true)) {
                    Text("Avvia il test del percorso")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .foregroundColor(InterfaceConstants.positiveLinkForegroundColor)
                }
            }
            
            Section(header: Text("Condivisione")) {
                Button(action: {
                    //Send route to user
                    print("Share tapped!")
                }) {
                    Text("Invia percorso")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .foregroundColor(InterfaceConstants.genericLinkForegroundColor)
                }
            }
        }.onAppear(perform: {
            print("appaio")
        })
            .navigationBarTitle(Text("Dettaglio percorso"), displayMode: .inline)
    }
    
    struct ChangeRouteName: View {
        @ObservedObject var route: Route
        @State var isEditing = false
        
        var body: some View {
            Form {
                Section(header: Text("Modifica nome")) {
                    ZStack(alignment: .trailing) {
                        TextField("Name", text: $route.routeName, onEditingChanged: {_ in self.isEditing = true})
                        Button(action: {
                            self.route.routeName = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                                .opacity((!self.isEditing || self.route.routeName == "") ? 0 : 1)
                        }
                    }
                    
                }
            }
            .navigationBarTitle(Text("Nome"), displayMode: .inline)
            .onDisappear(perform: updateRoute)
        }
        
        func updateRoute() {
            RoutesFactory.getInstance().setRoutes(routes: RoutesFactory.getInstance().getRoutes())
        }
    }
}

/*struct RouteDetail_Previews: PreviewProvider {
 static var previews: some View {
 RouteDetail(route: Route(routeName: "Prima", user: "Filippo", caregiver: CaregiverFactory().caregivers[0], mapRoute: MapRoutesFactory().mapRoutes[0]))
 }
 }*/
