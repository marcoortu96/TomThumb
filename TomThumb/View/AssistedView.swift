//
//  AssistedView.swift
//  TomThumb
//
//  Created by Marco Ortu on 18/08/2020.
//  Copyright © 2020 Sora. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseDatabase
import MapKit

struct AssistedView: View {
    @State var textFromDB = ""
    @State var route = Route()
    @State var showMap = false
    @State private var locations = [MKPointAnnotation]()
    @State var collected = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                if !showMap {
                    Text("Premi aggiorna per caricare la mappa")
                }
                if showMap {
                    LiveMapView(route: route, annotations: locations, collected: $collected).edgesIgnoringSafeArea(.all)
                }
                Button(action: {
                    self.readDataFromDB()
                    self.showMap = true
                }) {
                    Image(systemName: "repeat")
                        .foregroundColor(.white)
                }
                .padding()
                .background(Color.blue.opacity(0.85))
                .font(.title)
                .clipShape(Circle())
                .padding(.top, (UIScreen.main.bounds.size.height/100) * 65)
                .padding(.leading, (UIScreen.main.bounds.size.width/100) * 77)
                
                if showMap {
                    ZStack {
                        Text("\(self.collected)/\(route.mapRoute.crumbs.count)")
                        Circle()
                            .fill(Color.clear)
                            .frame(width: 50, height: 50)
                            .overlay(
                                Circle()
                                    .trim(from: 0, to: CGFloat((Double(Double(self.collected) / Double(route.mapRoute.crumbs.count)) * 100) * (0.01)))
                                    .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                                    .fill(Color.red)
                        )
                        
                    }.padding(.bottom, (UIScreen.main.bounds.size.height/100) * 68)
                        .padding(.trailing, (UIScreen.main.bounds.size.width/100) * 75)
                }
            }.onAppear(perform: {
                self.readDataFromDB()
            })
                .navigationBarTitle(Text("\(self.route.routeName)"), displayMode: .inline)
            
        }.onDisappear(perform: {
            self.locations = []
            self.showMap = false
        })
    }
    
    func getRouteDataFromDB() {
        let dbRef = Database.database().reference()
        
        if self.route.routeName == "" {
            dbRef.child("Routes").child("\(self.route.id)").observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? [String : Any]
                print("value \n \(value ?? ["result" : ["error" : "cannot retrive values from DB"]])")
                var crumbs = [Crumb]()
                //print(value!["crumbs"]!)
                for crumb in value?["crumbs"] as! [[String : Any]] {
                    //print(crumb["audio"])
                    crumbs.append(Crumb(location: CLLocation(latitude: crumb["latitude"] as! Double, longitude: crumb["longitude"] as! Double), audio: URL(fileURLWithPath: crumb["audio"] as! String)))
                }
                let routeTmp = Route(id: self.route.id,
                                     routeName: value!["routeName"] as! String,
                                     startName: value!["startName"] as! String,
                                     finishName: value!["finishName"] as! String,
                                     caregiver: CaregiverFactory().caregivers[0],
                                     mapRoute: MapRoute(crumbs: crumbs)
                )
                self.route = routeTmp
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        
    }
    
    func readDataFromDB() {
        let ref = Database.database().reference()
        ref.child("Assisted").observe(.value, with: { (snapshot) in
            
            // Get user position value
            let value = snapshot.value as? NSDictionary
            print("value \n \(value ?? ["error" : "cannot retrive values from DB"])")
            self.route.id = value?["id"] as? String ?? "err"
            let lat = value?["latitude"] as? Double ?? 0.0
            let lon = value?["longitude"] as? Double ?? 0.0
            let collected = value?["collected"] as? Int ?? -1
            
            
            if self.route.routeName == "" {
                ref.child("Routes").child("\(self.route.id)").observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as? [String : Any]
                    print("value \n \(value ?? ["result" : ["error" : "cannot retrive values from DB"]])")
                    var crumbs = [Crumb]()
                    //print(value!["crumbs"]!)
                    for crumb in value?["crumbs"] as! [[String : Any]] {
                        //print(crumb["audio"])
                        crumbs.append(Crumb(location: CLLocation(latitude: crumb["latitude"] as! Double, longitude: crumb["longitude"] as! Double), audio: URL(fileURLWithPath: crumb["audio"] as! String)))
                    }
                    let routeTmp = Route(id: self.route.id,
                                         routeName: value!["routeName"] as! String,
                                         startName: value!["startName"] as! String,
                                         finishName: value!["finishName"] as! String,
                                         caregiver: CaregiverFactory().caregivers[0],
                                         mapRoute: MapRoute(crumbs: crumbs)
                    )
                    self.route = routeTmp
                    
                    if self.route.mapRoute.crumbs.count > 1 {
                        let startAnnotation = MKPointAnnotation()
                        startAnnotation.coordinate = self.route.mapRoute.crumbs[0].location.coordinate
                        startAnnotation.title = "start"
                        self.locations.append(startAnnotation)
                        
                        let finishAnnotation = MKPointAnnotation()
                        finishAnnotation.coordinate = self.route.mapRoute.crumbs[self.route.mapRoute.crumbs.count - 1].location.coordinate
                        finishAnnotation.title = "finish"
                        self.locations.append(finishAnnotation)
                        
                        for (index,crumb) in self.route.mapRoute.crumbs[1..<(self.route.mapRoute.crumbs.count - 1)].enumerated() {
                            let crumbAnnotation = MKPointAnnotation()
                            crumbAnnotation.coordinate =  crumb.location.coordinate
                            crumbAnnotation.title = String(index + 1)
                            crumbAnnotation.subtitle = "crumb"
                            self.locations.append(crumbAnnotation)
                        }
                    }
                    
                    let assistedAnnotation = MKPointAnnotation()
                    if self.locations.count > self.route.mapRoute.crumbs.count {
                        self.locations.removeLast(self.route.mapRoute.crumbs.count + 1)
                    }
                    assistedAnnotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                    assistedAnnotation.subtitle = "\(lat.short),\(lon.short)"
                    self.locations.append(assistedAnnotation)
                    self.collected = collected
                }) { (error) in
                    print(error.localizedDescription)
                }
            }
            
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
}

