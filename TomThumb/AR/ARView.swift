//
//  ARView.swift
//  TomThumb
//
//  Created by Andrea Re on 13/07/2020.
//  Copyright © 2020 Sora. All rights reserved.
//

import SwiftUI

struct ARView: View {
    @ObservedObject var locationManager = LocationManager()
    var route: MapRoute
    
    var body: some View {
        ZStack {
            ARViewController(route: route)
            //NewNewARViewController(route: route)
            HStack() {
                Text("lat: \(Double((self.locationManager.currentLocation?.coordinate.latitude)!))")
                Text("lon: \(Double((self.locationManager.currentLocation?.coordinate.longitude)!))")
                Text("alt: \(Double((self.locationManager.currentLocation?.altitude)!))")
            }.background(Color.black)
            .foregroundColor(.white)
            .padding(.top, (UIScreen.main.bounds.size.height/100) * 70)
        }
    }
}
/*
struct ARView_Previews: PreviewProvider {
    static var previews: some View {
        ARView()
    }
}
*/
