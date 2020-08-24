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
    //@Binding var pushView: Bool
    var body: some View {
        TabView {
            RoutesView().tabItem {
                    VStack {
                        Image(systemName: "list.bullet")
                        Text("Percorsi")
                    }
            }.tag(0)
            AssistedView().tabItem {
                    VStack {
                        Image(systemName: "goforward")
                        Text("Esecuzione")
                    }
            }.tag(1)
            SettingsView().tabItem {
                VStack {
                    Image(systemName: "gear")
                    Text("Impostazioni")
                }
            }
            .tag(2)
        }
    }
}

/*struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}*/
