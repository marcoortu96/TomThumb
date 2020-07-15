//
//  RouteDetail.swift
//  TomThumb
//
//  Created by Andrea Re on 13/07/2020.
//  Copyright © 2020 Sora. All rights reserved.
//

import SwiftUI

struct RouteDetail: View {
    var route: Route
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
            Form {
                Section(header: Text("Dettagli")) {
                    HStack {
                        Text("Utente")
                        Spacer()
                        Text(route.user).foregroundColor(InterfaceConstants.secondaryInfoForegroundColor)
                    }
                    HStack {
                        Text("#Molliche")
                        Spacer()
                        Text("\(route.crumbs)").foregroundColor(InterfaceConstants.secondaryInfoForegroundColor)
                    }
                    HStack {
                        Text("Durata")
                        Spacer()
                        Text("\(route.duration)").foregroundColor(InterfaceConstants.secondaryInfoForegroundColor)
                    }
                }
                Section(header: Text("Mappa")) {
                    NavigationLink(destination: RouteMap(mapRoute: route.mapRoute)) {
                        Text("Visualizza il percorso")
                    }.accentColor(InterfaceConstants.genericlinkForegroundColor)
                }
                Section(header: Text("Condivisione")) {
                    Button(action: {
                        //Send route to user
                        print("Share tapped!")
                    }) {
                        HStack {
                            Text("Invia percorso")
                            
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .foregroundColor(InterfaceConstants.genericlinkForegroundColor)
                    }
                }
            }.navigationBarTitle(Text(route.routeName), displayMode: .inline)
    }
    
}



struct RouteDetail_Previews: PreviewProvider {
    static var previews: some View {
        RouteDetail(route: Route(routeName: "Prima", user: "Filippo", crumbs: 10, duration: TimeInterval(1000),  distance: 500.0, caregiver: CaregiverFactory().caregivers[0], mapRoute: MapRoutesFactory().mapRoutes[0]))
    }
}
