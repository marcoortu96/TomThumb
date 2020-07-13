//
//  SettingView.swift
//  TomThumb
//
//  Created by Marco Ortu on 13/07/2020.
//  Copyright © 2020 Sora. All rights reserved.
//

import SwiftUI

struct SettingView: View {
    @State private var previewIndex = 0
    var previewOptions = ["Default"]
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Profilo")) {
                        NavigationLink(destination: profileDetail(caregiver: CaregiverFactory().caregivers[1])) {
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
                    Section(header: Text("Audio")) {
                        Picker(selection: $previewIndex, label: Text("Inizio percorso")) {
                            ForEach(0 ..< previewOptions.count) {
                                Text(self.previewOptions[$0])
                            }
                        }
                        Picker(selection: $previewIndex, label: Text("Mollica raccolta")) {
                            ForEach(0 ..< previewOptions.count) {
                                Text(self.previewOptions[$0])
                            }
                        }
                        Picker(selection: $previewIndex, label: Text("Fine Percorso")) {
                            ForEach(0 ..< previewOptions.count) {
                                Text(self.previewOptions[$0])
                            }
                        }
                        Picker(selection: $previewIndex, label: Text("Fuori Traiettoria")) {
                            ForEach(0 ..< previewOptions.count) {
                                Text(self.previewOptions[$0])
                            }
                        }
                    }
                    Section {
                        Button(action: {
                            print("Perform an action here...")
                        }) {
                            Text("Logout").frame(minWidth: 0, maxWidth: .infinity).accentColor(.red)
                        }
                    }
                }
            }
            .navigationBarTitle("Impostazioni")
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
