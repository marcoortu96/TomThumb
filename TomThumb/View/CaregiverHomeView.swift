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
    @State var navBarHidden: Bool = true
    var body: some View {
        TabView {
            RoutesView().tabItem {
                    VStack {
                        Image(systemName: "list.bullet")
                        Text("Percorsi")
                            .navigationBarHidden(true)
                            .navigationBarBackButtonHidden(true)
                    }
            }.tag(0)
            AssistedView().tabItem {
                    VStack {
                        Image(systemName: "goforward")
                        Text("Esecuzione")
                            .navigationBarHidden(true)
                            .navigationBarBackButtonHidden(true)
                    }
            }.tag(1)
            SettingsView().tabItem {
                VStack {
                    Image(systemName: "gear")
                    Text("Impostazioni")
                        .navigationBarHidden(true)
                        .navigationBarBackButtonHidden(true)
                        
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
