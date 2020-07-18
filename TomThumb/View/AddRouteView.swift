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
                                newLocation.title = self.locations.count == 0 ? "start" : String(self.locations.count)
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
                    //Remove last annotation
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
                    
                    Button(action: {
                        //Save new route
                        var crumbs: [CLLocationCoordinate2D] = []
                        var start: CLLocationCoordinate2D
                        var finish: CLLocationCoordinate2D
                        
                        for loc in self.locations {
                            crumbs.append(CLLocationCoordinate2D(latitude: loc.coordinate.latitude, longitude: loc.coordinate.longitude))
                        }
                        start = crumbs[0]
                        finish = crumbs[crumbs.count-1]
                        crumbs.removeFirst()
                        crumbs.removeLast()
                        let mapRoute = MapRoute(start: start, crumbs: crumbs, finish: finish)
                        let newRoute = Route(routeName: "New", user: ChildFactory().children[0].name, caregiver: CaregiverFactory().caregivers[0], mapRoute: mapRoute)
                        RoutesFactory.insertRoute(route: newRoute)
                        self.showSheetView = false
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
                self.showSheetView = false
            }) {
                Text("Indietro").bold()
            })
        }
    }
}
