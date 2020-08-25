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
    @State var isNavigationBarHidden: Bool = true
    @State var route = Route()
    var body: some View {
        TabView {
            RoutesView().tabItem {
                VStack {
                    Image(systemName: "list.bullet")
                    Text("Percorsi")
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
            AssistedView(route: route).tabItem {
                VStack {
                    Image(systemName: "goforward")
                    Text("Esecuzione")
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
            SettingsView().tabItem {
                VStack {
                    Image(systemName: "gear")
                    Text("Impostazioni")
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
            .tag(2)
            .onAppear {
                self.isNavigationBarHidden = true
            }
        }
    }
}

/*struct ContentView_Previews: PreviewProvider {
 static var previews: some View {
 ContentView()
 }
 }*/
