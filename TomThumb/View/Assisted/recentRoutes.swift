//
//  recentRoutes.swift
//  TomThumb
//
//  Created by Marco Ortu on 24/08/2020.
//  Copyright © 2020 Sora. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseDatabase
import MapKit

struct RecentRoutes: View {
    @State private var searchText = ""
    @State var routes = [Route]()
    @State var showingActivityIndicator = true
    
    var body: some View {
        LoadingView(isShowing: $showingActivityIndicator, string: "Connessione") {
            NavigationView {
                VStack {
                    SearchBar(searchText: self.$searchText)
                    List {
                        ForEach(self.routes.sorted(by: {$0.routeName < $1.routeName}).filter {
                            self.searchText == "" ? true : $0.routeName.localizedCaseInsensitiveContains(self.searchText)
                        }, id: \.self) { route in
                            NavigationLink(destination: RouteDetail(route: route)) {
                                Text("\(route.routeName)")
                            }
                        }
                    }
                }
                .navigationBarTitle("Percorsi recenti")
                
            }
        }.onAppear {
            self.checkConnection()
            Database.database().reference().child("Routes").observe(DataEventType.value, with: { (snapshot) in
                if snapshot.childrenCount > 0 {
                    self.getRoutesFromDb()
                } else {
                    print("Non ci sono percorsi")
                }
            })
            
        }.onDisappear {
            self.showingActivityIndicator = true
        }
        .accentColor(InterfaceConstants.genericLinkForegroundColor)
    }
    
    func checkConnection() {
        let connectedRef = Database.database().reference(withPath: ".info/connected")
        connectedRef.observe(.value, with: { snapshot in
            if let connected = snapshot.value as? Bool, connected {
                self.showingActivityIndicator = false
            } else {
                self.showingActivityIndicator = true
            }
        })
    }
    
    // Func per scaricare i percorsi dal DB
    func getRoutesFromDb() {
        let db = Database.database().reference()
        
        db.child("Routes").observe(.value, with: { (snapshot) in
            let snapValue = snapshot.value as? [String : [String : Any]]
            print("value \n \(snapValue ?? ["result" : ["error" : "cannot retrive values from DB"]])")
            for (key, value) in snapValue! {
                var crumbs = [Crumb]()
                if value["lastExecution"] as! String != "" {
                    for crumb in value["crumbs"] as! [[String : Any]] {
                        //print(crumb["audio"])
                        crumbs.append(Crumb(location: CLLocation(latitude: crumb["latitude"] as! Double, longitude: crumb["longitude"] as! Double), audio: URL(fileURLWithPath: crumb["audio"] as! String)))
                    }
                    
                    let route = Route(id: String(key),
                                      routeName: value["routeName"] as! String,
                                      startName: value["startName"] as! String,
                                      finishName: value["finishName"] as! String,
                                      caregiver: CaregiverFactory().caregivers[0],
                                      lastExecution: value["lastExecution"] as! String,
                                      mapRoute: MapRoute(crumbs: crumbs)
                    )
                    if !self.routes.contains(route) {
                        self.routes.append(route)
                    }
                    
                    self.routes.sort(by: {$0.lastExecution < $1.lastExecution})
                }
            }
            self.showingActivityIndicator = false
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
}
