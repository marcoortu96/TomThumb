//
//  SettingsView.swift
//  TomThumb
//
//  Created by Marco Ortu on 13/07/2020.
//  Copyright © 2020 Sora. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
                Form {
                    Section(header: Text("Profilo")) {
                        NavigationLink(destination: ProfileDetail(caregiver: CaregiverFactory().caregivers[1])) {
                            HStack {
                                Image(uiImage: CaregiverFactory().caregivers[1].img)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 70, height: 70, alignment: .center)
                                    .clipped()
                                    .clipShape(Circle())
                                    .shadow(radius: 1)
                                
                                VStack {
                                    Text(CaregiverFactory().caregivers[1].username).font(.title)
                                        
                                    Text(CaregiverFactory().caregivers[1].name).font(.caption)
                                }
                            }
                        }
                    }
                    Section {
                        Button(action: {
                            print("Perform an action here...")
                        }) {
                            Text("Logout").frame(minWidth: 0, maxWidth: .infinity).accentColor(InterfaceConstants.negativeLinkForegroundColor)
                        }
                    }
                }
                .navigationBarTitle("Impostazioni")
                .accentColor(InterfaceConstants.genericLinkForegroundColor)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
