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
    
    var body: some View {
        NavigationView {
            ZStack {
                if showMap {
                    LiveMapView(mapRoute: route.mapRoute, annotations: locations)
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
                .padding(.top, (UIScreen.main.bounds.size.height/100) * 70)
                .padding(.leading, (UIScreen.main.bounds.size.width/100) * 77)
                VStack {
                    Text(textFromDB)
                }
                .padding(.bottom, (UIScreen.main.bounds.size.height/100) * 70)
                .padding(.trailing, (UIScreen.main.bounds.size.width/100) * 40)
                }.onAppear(perform: {
                    self.readDataFromDB()
                })
                .navigationBarTitle(Text("\(self.locations.count)"), displayMode: .inline)
            
        }.onDisappear(perform: {
            
            print("vado via")
            self.showMap = false
        })
    }
    
    func readDataFromDB() {
        let ref = Database.database().reference()
        ref.child("Assisted").observe(.value, with: { (snapshot) in
            
            // Get user position value
            let value = snapshot.value as? NSDictionary
            print("value \n \(value)")
            let routeId = value?["id"] as? Int ?? 0
            let lat = value?["latitude"] as? Double ?? 0.0
            let lon = value?["longitude"] as? Double ?? 0.0
            let collected = value?["collected"] as? Int ?? -1
            
            let fac = RoutesFactory.getInstance().getById(id: routeId)
        
            //if fac != nil {
            self.route = fac
            //}
            
            if fac.mapRoute.crumbs.count > 1 {
                let startAnnotation = MKPointAnnotation()
                startAnnotation.coordinate = fac.mapRoute.crumbs[0].location.coordinate
                startAnnotation.title = "start"
                self.locations.append(startAnnotation)
                
                let finishAnnotation = MKPointAnnotation()
                finishAnnotation.coordinate = fac.mapRoute.crumbs[fac.mapRoute.crumbs.count - 1].location.coordinate
                finishAnnotation.title = "finish"
                self.locations.append(finishAnnotation)
                
                for (index,crumb) in fac.mapRoute.crumbs[1..<(fac.mapRoute.crumbs.count - 1)].enumerated() {
                    let crumbAnnotation = MKPointAnnotation()
                    crumbAnnotation.coordinate =  crumb.location.coordinate
                    crumbAnnotation.title = String(index + 1)
                    crumbAnnotation.subtitle = String("\(crumb.location)")
                    self.locations.append(crumbAnnotation)
                }
            }
            
            let assistedAnnotation = MKPointAnnotation()
            if self.locations.count > self.route.mapRoute.crumbs.count {
                self.locations.removeLast(self.route.mapRoute.crumbs.count + 1)
            }
            assistedAnnotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            self.locations.append(assistedAnnotation)
            
        
            
            self.textFromDB = "lat: \(lat)\nlon: \(lon) \nid: \(routeId) \n collected: \(collected)"
            
            //print(self.textFromDB)
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
}

