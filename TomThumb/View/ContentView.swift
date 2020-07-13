//
//  ContentView.swift
//  TomThumb
//
//  Created by Marco Ortu on 13/07/2020.
//  Copyright © 2020 Sora. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 0

    var body: some View {
        TabView {
            RoutesView()
                .tabItem {
                    VStack {
                        Image(systemName: "list.bullet")
                        Text("Percorsi")
                    }
            }.tag(0)
            ARView()
                .tabItem {
                    VStack {
                        Image(systemName: "goforward")
                        Text("Esecuzione")
                    }
            }.tag(1)
            addRouteView().tabItem {
                VStack {
                    Image(systemName: "plus.square")
                    Text("Aggiungi")
                }
            }
            .tag(2)
            
            SettingView().tabItem {
                VStack {
                    Image(systemName: "gear")
                    Text("Impostazioni")
                }
            }
            .tag(3)
        }.onAppear {
            UITabBar.appearance().backgroundColor = .gray
        }.accentColor(.green)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
