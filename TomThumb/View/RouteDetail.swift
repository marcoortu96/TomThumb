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
                    Text("Inizo")
                    Spacer()
                    Text("\(getAddressName(route: route.mapRoute, index: 0))").foregroundColor(InterfaceConstants.secondaryInfoForegroundColor)
                }
                HStack {
                    Text("Fine")
                    Spacer()
                    Text("\(getAddressName(route: route.mapRoute, index: route.mapRoute.crumbs.count-1))").foregroundColor(InterfaceConstants.secondaryInfoForegroundColor)
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
        }
        .navigationBarTitle(Text(route.routeName), displayMode: .inline)
    }
    
    // da FIXARE non esegue il reverseGeocoding
    func getAddressName(route: MapRoute, index: Int) -> String {
        let geocoder = CLGeocoder()
        var street = ""
        
        geocoder.reverseGeocodeLocation(route.crumbs[index].location) { (placemarks, error) in
            // Place details
            guard let placeMark = placemarks?.first else {
                print("non trovo l'indirizzo")
                return
            }
            
            let streetName = placeMark.thoroughfare ?? "Si è verificato un problema"
            let streetNum = placeMark.subThoroughfare ?? "Si è verificato un problema"
            DispatchQueue.main.async{
                street = "\(streetName), \(streetNum)"
            }
            print("eiii \(street)")
        }
        return street
    }
    
    
    struct ChangeRouteName: View {
        @State var route: Route
        
        var body: some View {
            Form {
                Section(header: Text("Modifica nome")) {
                    VStack {
                        TextField("Name", text: $route.routeName)
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
