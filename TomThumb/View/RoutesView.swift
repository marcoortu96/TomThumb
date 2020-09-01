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
    @State var showAddRouteView = false
    @ObservedObject var routesFactory = RoutesFactory.getInstance()
    @State var audioRecorder = AudioRecorder()
    @State var crumbAudio = URL(fileURLWithPath: "")
    @State var currentCrumb = Crumb(location: CLLocation())
    @State var crumbs = [Crumb]()
    @State var routes = [Route]()
    @State var isShowing = true
    var body: some View {
        LoadingView(isShowing: $isShowing, string: "Scarico i percorsi") {
            NavigationView {
                VStack {
                    SearchBar(searchText: self.$searchText)
                    List {
                        ForEach(self.routes.filter {
                            self.searchText == "" ? true : $0.routeName.localizedCaseInsensitiveContains(self.searchText)
                        }, id: \.self) { route in
                            NavigationLink(destination: RouteDetail(route: route)) {
                                Text("\(route.routeName)")
                            }
                        }
                        .onDelete(perform: self.deleteRoute)
                    }
                }
                .navigationBarTitle("Percorsi")
                .navigationBarItems(leading: EditButton(), trailing:
                    Button(action: {
                        self.showAddRouteView.toggle()
                    }) {
                        Image(systemName: "plus.circle").font(.largeTitle)
                    }
                )
            }
        }.onAppear {
            Database.database().reference().child("Routes").observe(DataEventType.value, with: { (snapshot) in
                if snapshot.childrenCount > 0 {
                    self.getRoutesFromDb()
                } else {
                    print("Non ci sono percorsi")
                }
            })
            
        }
        .accentColor(InterfaceConstants.genericLinkForegroundColor)
        .sheet(isPresented: self.$showAddRouteView) {
            //add new route view (load sheet)
            AddRouteView(showSheetView: self.$showAddRouteView, centerCoordinate: locationManager.location!.coordinate, audioRecorder: self.audioRecorder, crumbAudio: self.crumbAudio, currentCrumb: self.currentCrumb, crumbs: self.crumbs)
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
    
    // Func per scaricare i percorsi dal DB
    func getRoutesFromDb() {
        let db = Database.database().reference()
        
        db.child("Routes").observeSingleEvent(of: .value, with: { (snapshot) in
            let snapValue = snapshot.value as? [String : [String : Any]]
            //print("value \n \(snapValue ?? ["result" : ["error" : "cannot retrive values from DB"]])")
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
                                  mapRoute: MapRoute(crumbs: crumbs)
                )
                if !self.routes.contains(route) {
                    self.routes.append(route)   
                }
            }
            self.isShowing = false
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
}



/*struct RoutesView_Previews: PreviewProvider {
 static var previews: some View {
 RoutesView()
 }
 }*/

