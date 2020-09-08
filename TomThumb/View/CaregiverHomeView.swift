//
//  CaregiverHomeView.swift
//  TomThumb
//
//  Created by Marco Ortu on 13/07/2020.
//  Copyright © 2020 Sora. All rights reserved.
//

import SwiftUI
import MapKit

struct CaregiverHomeView: View {
    @State var route = Route()
    @EnvironmentObject var navBarPrefs: NavBarPreferences
    @State var navBarTitle = "Percorsi"
    
    @State var showAddRouteView = false
    
    var body: some View {
        TabView {
            RoutesView(showAddRouteView: $showAddRouteView)
                .tabItem {
                    VStack {
                        Image(systemName: "list.bullet")
                        Text("Percorsi")
                            .navigationBarBackButtonHidden(true)
                    }.navigationBarItems(trailing:
                        Button(action: {
                            self.showAddRouteView.toggle()
                        }) {
                            Image(systemName: "plus.circle.fill").font(.title)
                        }.opacity(self.navBarTitle == "Percorsi" ? 1.0 : 0.0)
                    )
            }
            .tag(0)
            .onAppear {
                self.navBarTitle = "Percorsi"
            }
            .onDisappear {
                self.navBarTitle = ""
            }
            
            AssistedView(route: route, routeName: $navBarTitle)
                .tabItem {
                    VStack {
                        Image(systemName: "goforward")
                        Text("Esecuzione")
                            .navigationBarBackButtonHidden(true)
                    }
            }
            .tag(1)
            .onAppear {
                self.navBarTitle = "Esecuzione"
            }
            
            SettingsView()
                .tabItem {
                    VStack {
                        Image(systemName: "gear")
                        Text("Impostazioni")
                            .navigationBarBackButtonHidden(true)
                    }
            }
            .tag(2)
            .onAppear {
                self.navBarTitle = "Impostazioni"
            }
            
        }
        .navigationBarTitle("\(navBarTitle)", displayMode: (navBarTitle == "Percorsi" || navBarTitle == "Impostazioni" || navBarTitle == "Esecuzione") ? .large : .inline)
        
        
    }
}
