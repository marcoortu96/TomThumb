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
    var body: some View {
        TabView {
            RoutesView().tabItem {
                VStack {
                    Image(systemName: "list.bullet")
                    Text("Percorsi")
                        .navigationBarBackButtonHidden(true)
                }
            }
            .tag(0)
            .onAppear {
                self.navBarPrefs.navBarIsHidden = true
            }
            AssistedView(route: route).tabItem {
                VStack {
                    Image(systemName: "goforward")
                    Text("Esecuzione")
                        .navigationBarBackButtonHidden(true)
                }
            }
            .tag(1)
            .onAppear {
                self.navBarPrefs.navBarIsHidden = true
            }
            SettingsView().tabItem {
                VStack {
                    Image(systemName: "gear")
                    Text("Impostazioni")
                        .navigationBarBackButtonHidden(true)
                }
            }
            .tag(2)
            .onAppear {
                self.navBarPrefs.navBarIsHidden = true
            }
        }
    }
}

/*struct ContentView_Previews: PreviewProvider {
 static var previews: some View {
 ContentView()
 }
 }*/
