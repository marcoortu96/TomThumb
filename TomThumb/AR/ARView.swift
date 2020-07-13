//
//  ARView.swift
//  TomThumb
//
//  Created by Andrea Re on 13/07/2020.
//  Copyright © 2020 Sora. All rights reserved.
//

import SwiftUI

struct ARView: View {
    @ObservedObject var locationViewModel = LocationManager()
    
    var body: some View {
        ZStack {
            ARViewController()
            HStack() {
                Text("Latitude: \(self.locationViewModel.userLatitude)")
                Text("Longitude: \(self.locationViewModel.userLongitude)")
            }.background(Color.black)
            .foregroundColor(.white)
            .padding(.top, (UIScreen.main.bounds.size.height/100) * 70)
        }
    }
}

struct ARView_Previews: PreviewProvider {
    static var previews: some View {
        ARView()
    }
}
