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
                
                Text(textFromDB)
                }.onAppear(perform: {
                    self.readDataFromDB()
                })
            .navigationBarTitle(Text("\(self.route.routeName)"), displayMode: .inline)
            
        }.onDisappear(perform: {
            
            print("vado via")
            self.showMap = false
        })
    }
    
    func readDataFromDB() {
        let ref = Database.database().reference()
        ref.child("Assisted").observeSingleEvent(of: .value, with: { (snapshot) in
            
            // Get user position value
            let value = snapshot.value as? NSDictionary
            let routeId = value?["id"] as? Int ?? -1
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
            assistedAnnotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            self.locations.append(assistedAnnotation)
            
        
            
            //self.textFromDB = "lat: \(lat)\n lon: \(lon) \n id: \(routeId) \n collected: \(collected)"
            
            //print(self.textFromDB)
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
}

