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

struct AssistedView: View {
    @State var textFromDB = ""
    @State var route = Route()
    @State var showMap = false
    
    var body: some View {
        NavigationView {
            ZStack {
                if showMap {
                    LiveMapView(mapRoute: route.mapRoute)
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
            .onDisappear(perform: {
                self.showMap = false
            }).navigationBarTitle(Text("\(self.route.routeName)"), displayMode: .inline)
            
        }
    }
    
    func readDataFromDB() {
        let ref = Database.database().reference()
        ref.child("Assisted").observe(.childAdded, with: { (snapshot) in
            
            // Get user position value
            let value = snapshot.value as? NSDictionary
            let routeName = value?["name"] as? String ?? "-1"
            let lat = value?["latitude"] as? Double ?? 0.0
            let lon = value?["longitude"] as? Double ?? 0.0
            let collected = value?["collected"] as? Int ?? -1
            
            let fac = RoutesFactory.getInstance().getByName(name: routeName)
            
            //if fac != nil {
            self.route = fac
            //}
        
            
            self.textFromDB = "lat: \(lat)\n lon: \(lon) \n \(routeName) \n \(collected)"
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
}

