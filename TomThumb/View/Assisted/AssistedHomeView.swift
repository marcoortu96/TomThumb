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
    var body: some View {
        TabView {
            ARView(route: route, debug: true)
                .tabItem {
                    VStack {
                        Image(systemName: "list.bullet")
                        Text("Percorso")
                            /*.navigationBarTitle("")
                            .navigationBarHidden(isNavigationBarHidden)
                            .navigationBarBackButtonHidden(isNavigationBarHidden)
                            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                                self.isNavigationBarHidden = true
                        }
                        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                            self.isNavigationBarHidden = false
                        }*/
                    }
            }
            .tag(0)
            .onAppear {
                self.isNavigationBarHidden = true
            }
            RecentRoutes()
                .tabItem {
                    VStack {
                        Image(systemName: "goforward")
                        Text("Recenti")
                            /*.navigationBarTitle("")
                            .navigationBarHidden(isNavigationBarHidden)
                            .navigationBarBackButtonHidden(isNavigationBarHidden)
                            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                                self.isNavigationBarHidden = true
                        }
                        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                            self.isNavigationBarHidden = false
                        }*/
                    }
            }
            .tag(1)
            .onAppear {
                self.isNavigationBarHidden = true
            }
        }
    }
}


