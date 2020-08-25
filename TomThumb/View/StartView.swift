//
//  StartView.swift
//  TomThumb
//
//  Created by Marco Ortu on 24/08/2020.
//  Copyright © 2020 Sora. All rights reserved.
//

import SwiftUI

struct StartView: View {
    @State var isNavigationBarHidden: Bool = true
    @State var route = Route()
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: CaregiverHomeView()
                    .navigationBarTitle("")
                    .navigationBarHidden(isNavigationBarHidden)
                    .navigationBarBackButtonHidden(isNavigationBarHidden)
                    .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                        self.isNavigationBarHidden = true
                    }
                    .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                        self.isNavigationBarHidden = false
                    }) {
                    HStack {
                        Image(systemName: "person.fill")
                            .accentColor(.black)
                            .font(.largeTitle)
                        Text("Caregiver")
                            .accentColor(.black)
                            .font(.largeTitle)
                            .edgesIgnoringSafeArea(.all)
                    }
                    .padding(.top, 50)
                    .padding(.bottom, 50)
                    .padding(.trailing, (UIScreen.main.bounds.size.width/100)*20)
                    .padding(.leading, (UIScreen.main.bounds.size.width/100)*20)
                    .cornerRadius(12)
                    .background(Color.green)
                }
                
                NavigationLink(destination: AssistedHomeView(route: route)
                    .navigationBarTitle("")
                    .navigationBarHidden(isNavigationBarHidden)
                    .navigationBarBackButtonHidden(isNavigationBarHidden)
                    .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                        self.isNavigationBarHidden = true
                    }
                    .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                        self.isNavigationBarHidden = false
                    }) {
                    HStack {
                        Image(systemName: "person.fill")
                            .accentColor(.black)
                            .font(.largeTitle)
                            .edgesIgnoringSafeArea(.all)
                        Text("Assistito")
                            .accentColor(.black)
                            .font(.largeTitle)
                    }
                    .padding(.top, 50)
                    .padding(.bottom, 50)
                    .padding(.trailing, (UIScreen.main.bounds.size.width/100)*22)
                    .padding(.leading, (UIScreen.main.bounds.size.width/100)*22)
                    .cornerRadius(12)
                    .background(Color.blue)
                }
                
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
    }
}

/*struct StartView_Previews: PreviewProvider {
 static var previews: some View {
 StartView(route: route)
 }
 }*/
