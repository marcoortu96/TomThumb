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
            Text("Item 3")
                .tabItem {
                    VStack {
                        Image(systemName: "plus.square.fill")
                        Text("Aggiungi")
                    }
            }.tag(2)
            Text("Item 4")
                .tabItem {
                    VStack {
                        Image(systemName: "gear")
                        Text("Impostazioni")
                    }
            }.tag(3)
        }.onAppear {
            UITabBar.appearance().backgroundColor = .gray
        }.accentColor(.black)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
