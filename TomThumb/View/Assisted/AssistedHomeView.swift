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
    @ObservedObject var route: Route
    @State var isNavigationBarHidden = true
    @EnvironmentObject var navBarPrefs: NavBarPreferences
    var body: some View {
        TabView {
            ARView(route: route, debug: true)
                .tabItem {
                    VStack {
                        Image(systemName: "location")
                        Text("Percorso")
                            .navigationBarBackButtonHidden(true)
                    }
            }
            .tag(0)
            .onAppear {
                self.navBarPrefs.navBarIsHidden = true
            }
            
            RecentRoutes()
                .tabItem {
                    VStack {
                        Image(systemName: "clock")
                        Text("Recenti")
                            .navigationBarBackButtonHidden(true)
                    }
            }
            .tag(1)
            .onAppear {
                self.navBarPrefs.navBarIsHidden = true
            }
        }
    }
}


