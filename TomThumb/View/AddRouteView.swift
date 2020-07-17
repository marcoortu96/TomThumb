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
    @State var centerCoordinate: CLLocationCoordinate2D
    @State private var locations = [MKPointAnnotation]()
    
    //@State var pin = MapPin(coordinate: locationManager.location!.coordinate, title: "", subtitle: "")

    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                SearchBar(searchText: $searchText)
                ZStack {
                    MapViewAddRoute(centerCoordinate: $centerCoordinate, annotations: locations)
                    Image(systemName: "largecircle.fill.circle")
                        .opacity(0.6)
                        .foregroundColor(.blue)
                        .font(.largeTitle)
                    VStack {
                        Spacer()
                        HStack {
                           Spacer()
                           Button(action: {
                               let newLocation = MKPointAnnotation()
                               newLocation.coordinate = self.centerCoordinate
                               self.locations.append(newLocation)
                           }) {
                               Image(systemName: "plus")
                                .foregroundColor(.white)
                           }
                           .padding()
                           .background(Color.green.opacity(0.85))
                           .font(.title)
                           .clipShape(Circle())
                           .padding(.trailing)
                           .padding(.bottom)
                        }
                    }
                    /*HStack{
                        Image(systemName: "info.circle.fill").font(.title).foregroundColor(.black)
                        VStack {
                            Text(pin.title!).font(.body).foregroundColor(.black)
                            Text(pin.subtitle!).font(.caption).foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .background(Color(.lightGray))
                    .cornerRadius(15)*/
                }
                HStack {
                    // Undo the last annotation
                    Button(action: {
                        if self.locations.count != 0 {
                           self.locations.remove(at: (self.locations.count-1))
                        }
                    }) {
                        Text("Annulla")
                            .foregroundColor(self.locations.count == 0 ? Color.red.opacity(0.3) : Color.red)
                    }
                    .padding()
                    .disabled(self.locations.count == 0)
                    Spacer()
                    
                    // Save route
                    Button(action: {
                        print("SAVEE")
                        var crumbs = [CLLocationCoordinate2D]()
                        var crumbStart: CLLocationCoordinate2D
                        var crumbFinish: CLLocationCoordinate2D
                        
                        for loc in self.locations {
                            crumbs.append(CLLocationCoordinate2D(latitude: loc.coordinate.latitude, longitude: loc.coordinate.longitude))
                        }
                        print("crumbs before: \(crumbs.count)")
                        crumbStart = crumbs[0]
                        crumbFinish = crumbs[crumbs.count-1]
                        crumbs.removeFirst()
                        crumbs.removeLast()
                        print("crumbs after: \(crumbs.count)")
                        /*RoutesFactory().routes.append(Route(routeName: "Percorso Cazzo", user: CaregiverFactory().caregivers[0].children[0].name, crumbs: self.locations.count, duration: TimeInterval(1000), distance: 500, caregiver: CaregiverFactory().caregivers[0], mapRoute: MapRoute(start: crumbs[0], crumbs: crumbs, finish: crumbs[crumbs.count-1])))*/
                        
                    }) {
                        Text("Salva")
                            .foregroundColor(self.locations.count <= 2 ? Color.blue.opacity(0.3) : Color.blue)
                    }
                    .padding()
                    .disabled(self.locations.count <= 2)
                }
            }
            .navigationBarTitle("Aggiungi", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                print("Dismissing sheet view...")
                self.showSheetView = false
            }) {
                Text("Indietro").bold()
            })
        }
    }
}

struct AddRouteView_Previews: PreviewProvider {
    static var previews: some View {
        AddRouteView(showSheetView: .constant(false), centerCoordinate: locationManager.location!.coordinate)
    }
}
