//
//  AssistedView.swift
//  TomThumb
//
//  Created by Marco Ortu on 24/08/2020.
//  Copyright © 2020 Sora. All rights reserved.
//

import SwiftUI
import MapKit

struct AssistedHomeView: View {
    @State var route = Route()
    //@Binding var pushView: Bool
    var body: some View {
        TabView {
            ARView(route: route, debug: true).tabItem {
                    VStack {
                        Image(systemName: "list.bullet")
                        Text("Percorso")
                            .navigationBarBackButtonHidden(true)
                            .navigationBarHidden(true)
                    }
            }.tag(0)
            recentRoutes().tabItem {
                    VStack {
                        Image(systemName: "goforward")
                        Text("Recenti")
                            .navigationBarBackButtonHidden(true)
                            .navigationBarHidden(true)
                    }
            }.tag(1)
        }
    }
}


