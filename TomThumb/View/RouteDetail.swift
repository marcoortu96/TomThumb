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
                        Text(route.user).foregroundColor(Color.gray)
                    }
                    HStack {
                        Text("#Molliche")
                        Spacer()
                        Text("\(route.crumbs)").foregroundColor(Color.gray)
                    }
                    HStack {
                        Text("Durata")
                        Spacer()
                        Text("\(route.duration)").foregroundColor(Color.gray)
                    }
                }
                Section(header: Text("Mappa")) {
                    NavigationLink(destination: RouteMap(mapRoute: route.mapRoute)) {
                        Text("Visualizza il percorso")
                    }
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
                        .foregroundColor(.blue)
                    }
                }
            }.navigationBarTitle(Text(route.routeName), displayMode: .inline)
    }
    
}



struct RouteDetail_Previews: PreviewProvider {
    static var previews: some View {
        RouteDetail(route: Route(routeName: "Prima", user: "Filippo", crumbs: 10, duration: TimeInterval(1000), caregiver: Caregiver(name: "Mario", surname: "Rossi", cellphone: "+393383838383"), mapRoute: MapRoutesFactory().mapRoutes[0]))
    }
}
