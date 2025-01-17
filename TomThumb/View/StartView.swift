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
                Image(uiImage: UIImage(named: "tomThumbIconFront")!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: (UIScreen.main.bounds.width/100) * 30, height: (UIScreen.main.bounds.height/100) * 30, alignment: .top)
                    .clipped()
                    .padding(.bottom, 15)
        
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
                    
                    .background(Color.green)
                    .opacity(1)
                }.cornerRadius(12)
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
                    
                    .background(Color.blue)
                    .opacity(1)
                }.cornerRadius(12)

            }
            .padding(.bottom, (UIScreen.main.bounds.height/100)*10)
            .navigationBarTitle(Text(""), displayMode: .inline)
            .navigationBarColor(UIColor.systemBackground)   
        }
        
    }
}

/*struct StartView_Previews: PreviewProvider {
 static var previews: some View {
 StartView(route: route)
 }
 }*/
