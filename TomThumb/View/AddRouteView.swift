//
//  AddRouteView.swift
//  TomThumb
//
//  Created by Marco Ortu on 13/07/2020.
//  Copyright © 2020 Sora. All rights reserved.
//

import SwiftUI
import MapKit

var locationManager = CLLocationManager()

struct AddRouteView: View {
    
    @Binding var showSheetView: Bool
    @State private var searchText = ""
    
    @State var pin = MapPin(coordinate: locationManager.location!.coordinate, title: "", subtitle: "")

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("  Inizio")
                    SearchBar(searchText: $searchText)
                }
                HStack {
                    Text("  Fine")
                    SearchBar(searchText: $searchText)
                }
                ZStack(alignment: .bottom, content: {
                    MapViewAddRoute(pin: self.$pin)
                    HStack {
                        Image(systemName: "info.circle.fill").font(.largeTitle).foregroundColor(.black)
                        VStack {
                            Text(pin.title!).font(.body).foregroundColor(.black)
                            Text(pin.subtitle!).font(.caption).foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .background(Color(.lightGray))
                    .cornerRadius(15)
                })
 
                Form {
                    Section(header: Text("Dettagli")) {
                        HStack {
                            Text("Distanza")
                            Spacer()
                            Text("100.0")
                        }
                        HStack {
                            Text("# Molliche")
                            Spacer()
                            Text("10")
                        }
                    }
                }
                .frame(height: 120.0)
            }
            .navigationBarTitle("Aggiungi")
            .navigationBarItems(trailing: Button(action: {
                print("Dismissing sheet view...")
                self.showSheetView = false
            }) {
                Text("Fatto").bold()
            })
        }
    }
}

struct AddRouteView_Previews: PreviewProvider {
    static var previews: some View {
        AddRouteView(showSheetView: .constant(false))
    }
}
