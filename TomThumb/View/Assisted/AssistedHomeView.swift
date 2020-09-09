//
//  AssistedView.swift
//  TomThumb
//
//  Created by Marco Ortu on 24/08/2020.
//  Copyright © 2020 Sora. All rights reserved.
//

import SwiftUI
import MapKit
import Firebase
import FirebaseDatabase

struct AssistedHomeView: View {
    @State var route = Route()
    @State var isExecuting = false
    @State var isNavigationBarHidden = true
    @EnvironmentObject var navBarPrefs: NavBarPreferences
    @State var navBarTitle = "Percorso"
    var body: some View {
        TabView {
            if !isExecuting {
                Text("Non ci sono percorsi da avviare")
                    .font(.headline)
                    .foregroundColor(InterfaceConstants.secondaryInfoForegroundColor)
                    .navigationBarBackButtonHidden(true)
                    .tabItem {
                        VStack {
                            Image(systemName: "location")
                            Text("Percorso")
                        }
                }
                .tag(0)
                .onAppear {
                    self.navBarTitle = "Percorso"
                }
            }
            else {
                NavigationLink(destination: ARView(route: route, debug: false).navigationBarTitle("").navigationBarHidden(true)
                    .navigationBarBackButtonHidden(true)){
                        Text("Avvia percorso")
                }
                .tabItem {
                    VStack {
                        Image(systemName: "location")
                        Text("Percorso")
                    }
                }
                .tag(0)
                .onAppear {
                    self.navBarTitle = "Nuovo percorso"
                    self.navBarPrefs.navBarIsHidden = true
                }
            }
            RecentRoutes()
                .tabItem {
                    VStack {
                        Image(systemName: "clock")
                        Text("Recenti")
                    }
            }
            .tag(1)
            .onAppear {
                self.navBarTitle = "Recenti"
                
            }
            .onDisappear {
                self.navBarTitle = "Percorso"
            }
        }.navigationBarTitle("\(navBarTitle)", displayMode: .large)
            .navigationBarBackButtonHidden(true)
            .onAppear{
                self.fetchNewRoute()
        }
        
    }
    
    func fetchNewRoute() {
        let ref = Database.database().reference()
        
        ref.child("Assisted").observe(.value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let isExecuting = value?["isExecuting"] as! Bool
            let id = value?["id"] as! String
            self.isExecuting = isExecuting
            
            if isExecuting {
                ref.child("Routes").child("\(id)").observe(.value, with: { (snapshot) in
                    let value = snapshot.value as? [String : Any]
                    print("value \n \(value ?? ["result" : ["error" : "cannot retrive values from DB"]])")
                    var crumbs = [Crumb]()
                    //print(value!["crumbs"]!)
                    for crumb in value?["crumbs"] as! [[String : Any]] {
                        //print(crumb["audio"])
                        crumbs.append(Crumb(location: CLLocation(latitude: crumb["latitude"] as! Double, longitude: crumb["longitude"] as! Double), audio: URL(fileURLWithPath: crumb["audio"] as! String)))
                    }
                    let routeTmp = Route(id: id,
                                         routeName: value!["routeName"] as! String,
                                         startName: value!["startName"] as! String,
                                         finishName: value!["finishName"] as! String,
                                         caregiver: CaregiverFactory().caregivers[0],
                                         lastExecution: value!["lastExecution"] as! String,
                                         mapRoute: MapRoute(crumbs: crumbs)
                    )
                    self.route = routeTmp
                })
            }
            
        })
    }
}


