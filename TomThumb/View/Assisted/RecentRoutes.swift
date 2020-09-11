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
    @State var presentAlert = false
    @State var gridRoutes = [[Route]]()
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var navBarPrefs: NavBarPreferences
    
    var body: some View {
        LoadingView(isShowing: $showingActivityIndicator, string: "Connessione") {
            VStack {
                if self.routes.count == 0 {
                    Text("Non ci sono percorsi recenti")
                    .font(.headline)
                    .foregroundColor(InterfaceConstants.secondaryInfoForegroundColor)
                } else {
                    SearchBar(searchText: self.$searchText)
                    ScrollView {
                        ForEach(0..<self.gridRoutes.count, id: \.self) { index in
                            HStack {
                                ForEach(self.gridRoutes[index].filter {
                                    self.searchText == "" ? true : $0.routeName.localizedCaseInsensitiveContains(self.searchText)
                                }.indices) { item in
                                    HStack {
                                    GeometryReader { _ in
                                        Image(systemName: "map.fill")
                                            .foregroundColor(Color.white)
                                            .font(.title)
                                            .padding(.top)
                                            .padding(.leading)
                                        NavigationLink(destination: ARView(route: self.gridRoutes[index][item], debug: false).navigationBarTitle("").navigationBarHidden(true)) {
                                            Text(self.gridRoutes[index][item].routeName)
                                                .padding(.top, 60)
                                                .padding(.horizontal, 8)
                                                .font(Font.system(size: 15, weight: .bold))
                                            
                                        }.foregroundColor(Color.white)
                                    }
                                    .background(Color(UIColor.getColor(i: index, j: item)))
                                    .frame(width: (UIScreen.main.bounds.size.width/100) * 45, height: 100)
                                    }.cornerRadius(12)

                                }
                                
                            }
                        }
                    }
                }
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
            //print("value \n \(snapValue ?? ["result" : ["error" : "cannot retrive values from DB"]])")
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
                    self.gridRoutes = self.routes.chunked(into: 2)
                }
            }
            self.showingActivityIndicator = false
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
}
