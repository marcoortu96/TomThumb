//
//  RoutesView.swift
//  TomThumb
//
//  Created by Andrea Re on 13/07/2020.
//  Copyright © 2020 Sora. All rights reserved.
//

import SwiftUI
import MapKit
import Firebase
import FirebaseStorage
import FirebaseDatabase


struct RoutesView: View {
    @State private var searchText = ""
    @Binding var showAddRouteView: Bool
    @State var audioRecorder = AudioRecorder()
    @State var crumbAudio = URL(fileURLWithPath: "")
    @State var currentCrumb = Crumb(location: CLLocation())
    @State var crumbs = [Crumb]()
    @State var routes = [Route]()
    @State var showingActivityIndicator = true
    @State var gridRoutes = [[Route]]()    
    
    var body: some View {
        LoadingView(isShowing: $showingActivityIndicator, string: "Connessione") {
            VStack {
                if self.routes.count == 0 {
                    Text("Non ci sono percorsi.\nPremi su '+' per crearne uno.")
                        .multilineTextAlignment(.center)
                        .font(.headline)
                        .foregroundColor(InterfaceConstants.secondaryInfoForegroundColor)
                } else {
                    SearchBar(searchText: self.$searchText)
                    ScrollView {
                        ForEach(0..<self.routes.chunked(into: 2).count, id: \.self) { index in
                            HStack {
                                ForEach(self.routes.chunked(into: 2)[index].filter {
                                    self.searchText == "" ? true : $0.routeName.localizedCaseInsensitiveContains(self.searchText)
                                }) { route in
                                    HStack {
                                    GeometryReader { _ in
                                        Image(systemName: "map.fill")
                                            .font(.title)
                                            .padding(.top)
                                            .padding(.leading)
                                        NavigationLink(destination: RouteDetail(route: route)) {
                                            Text(route.routeName)
                                                .padding(.top, 60)
                                                .padding(.horizontal, 5)
                                            
                                                .font(Font.system(size: 15, weight: .bold))
                                    
                                            
                                        }.foregroundColor(Color.white)
                                    }
                                    .background(Color(UIColor.colors[(index + route.routeName.count) % UIColor.colors.count]))
                                    .frame(width: (UIScreen.main.bounds.size.width/100) * 45, height: 100)
                                    }.cornerRadius(12)

                                }
                                
                            }
                        }
                    }
                    
                    
                }
            }
            .navigationBarTitle("Percorsi")
            
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
        .sheet(isPresented: self.$showAddRouteView) {
            //add new route view (load sheet)
            if CLLocationManager.authorizationStatus() == .authorizedAlways {
                LoadingView(isShowing: self.$showingActivityIndicator, string: "Connessione") {
                    AddRouteView(showSheetView: self.$showAddRouteView, centerCoordinate: locationManager.location!.coordinate, audioRecorder: self.audioRecorder, crumbAudio: self.crumbAudio, currentCrumb: self.currentCrumb, crumbs: self.crumbs)
                }
            } else {
                GeometryReader { _ in
                    VStack {
                        Text("Imposta la posizione in\n \"consenti sempre\"")
                        Divider()
                        Button(action: {
                            self.showAddRouteView = false
                            UIApplication.shared.open(URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(Bundle.main.bundleIdentifier!)")!)
                        }) {
                            Text("Impostazioni")
                        }
                    }
                    
                }
                .background(Color.gray)
                .cornerRadius(15)
                .frame(width: (UIScreen.main.bounds.size.width/100) * 75, height: (UIScreen.main.bounds.size.height/100) * 20)
            }
        }
    }
    
    func deleteRoute(at offsets: IndexSet) {
        let db = Database.database().reference()
        
        // Rimozione della route dal db
        
        db.child("Routes").child(self.routes[offsets.first!].id).removeValue() { (error, ref) in
            if error != nil {
                print("error \(error.debugDescription)")
            }
        }
        
        // Rimozione della route dalla lista delle route mostrate nella view
        self.routes.remove(atOffsets: offsets)
        
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
        
        db.child("Routes").observeSingleEvent(of: .value, with: { (snapshot) in
            let snapValue = snapshot.value as? [String : [String : Any]]
            //print("value BBBBBBBBBBB \n \(snapValue ?? ["result" : ["error" : "cannot retrive values from DB"]])")
            self.routes = []
            for (key, value) in snapValue! {
                var crumbs = [Crumb]()
                
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
                
                self.routes.sort(by: {$0.routeName < $1.routeName})
                
            }
            print(self.routes.chunked(into: 2))
            self.showingActivityIndicator = false
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
}
