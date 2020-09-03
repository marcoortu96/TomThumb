//
//  StartView.swift
//  TomThumb
//
//  Created by Marco Ortu on 24/08/2020.
//  Copyright © 2020 Sora. All rights reserved.
//

import SwiftUI

struct StartView: View {
    @State var route = Route()
    @EnvironmentObject var navBarPrefs: NavBarPreferences
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: CaregiverHomeView()) {
                    HStack {
                        Image(systemName: "person.fill")
                            .accentColor(.black)
                            .font(.title)
                        Text("Caregiver")
                            .accentColor(.black)
                            .font(.system(size: (UIScreen.main.bounds.size.width/100)*7))
                            
                    }
                    .padding(.top, 50)
                    .padding(.bottom, 50)
                    .padding(.trailing, (UIScreen.main.bounds.size.width/100)*20)
                    .padding(.leading, (UIScreen.main.bounds.size.width/100)*20)
                    .cornerRadius(12)
                    .background(Color.green)
                    .edgesIgnoringSafeArea(.all)
                }
                .navigationBarTitle("", displayMode: .inline)
                .navigationBarHidden(self.navBarPrefs.navBarIsHidden)
                .navigationBarBackButtonHidden(self.navBarPrefs.navBarIsHidden)
                .onAppear {
                     self.navBarPrefs.navBarIsHidden = true
                }
                NavigationLink(destination: AssistedHomeView()) {
                    HStack {
                        Image(systemName: "person.fill")
                            .accentColor(.black)
                            .font(.title)
                        Text("Assistito")
                            .accentColor(.black)
                            .font(.system(size: (UIScreen.main.bounds.size.width/100)*7))
                            
                    }
                    .padding(.top, 50)
                    .padding(.bottom, 50)
                    .padding(.trailing, (UIScreen.main.bounds.size.width/100)*22)
                    .padding(.leading, (UIScreen.main.bounds.size.width/100)*22)
                    .cornerRadius(12)
                    .background(Color.blue)
                    .edgesIgnoringSafeArea(.all)
                }
                .navigationBarTitle("", displayMode: .inline)
                .navigationBarHidden(false)
                .navigationBarBackButtonHidden(false)
                .onAppear {
                     self.navBarPrefs.navBarIsHidden = false
                }

            }
        }
    }
}

/*struct StartView_Previews: PreviewProvider {
 static var previews: some View {
 StartView(route: route)
 }
 }*/
