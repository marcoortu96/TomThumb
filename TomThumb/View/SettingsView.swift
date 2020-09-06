//
//  SettingsView.swift
//  TomThumb
//
//  Created by Marco Ortu on 13/07/2020.
//  Copyright © 2020 Sora. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @State private var searchText = ""
    @State var showingAudioAlert = false
    @ObservedObject var audioRecorder = AudioRecorder()
    @State var selectedAudio = URL(fileURLWithPath: "")
    @State var audioName = ""
    
    var body: some View {
        VStack {
            PreventCollapseView()
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
                Section(header: Text("Audio")) {
                    NavigationLink(destination: Audio(showingAudioAlert: self.$showingAudioAlert, audioRecorder: self.audioRecorder, selectedAudio: self.selectedAudio, audioName: self.selectedAudio.lastPathComponent)) {
                        Text("Gestisci audio")
                    }
                }
                Section(header: Text("Audio emergenze")) {
                    NavigationLink(destination: Audio(showingAudioAlert: self.$showingAudioAlert, audioRecorder: self.audioRecorder, selectedAudio: self.selectedAudio, audioName: self.selectedAudio.lastPathComponent)) {
                        Text("Allonatanamento dal percorso")
                    }
                    NavigationLink(destination: Audio(showingAudioAlert: self.$showingAudioAlert, audioRecorder: self.audioRecorder, selectedAudio: self.selectedAudio, audioName: self.selectedAudio.lastPathComponent)) {
                        Text("Imprevisti")
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
            
        } .navigationBarTitle("Impostazioni", displayMode: .large)
            .accentColor(InterfaceConstants.genericLinkForegroundColor)
    }
}

struct Audio: View {
    @Binding var showingAudioAlert: Bool
    @ObservedObject var audioRecorder: AudioRecorder
    @State var selectedAudio: URL
    @State var audioName: String
    @State var infoRec = "Registra"
    
    var body: some View {
        VStack(alignment: .center) {
            RecordingsListSettings(audioRecorder: self.audioRecorder, selectedAudio: self.$selectedAudio, audioName: self.$audioName)
            if self.audioRecorder.recording == false {
                Button(action: {
                    self.audioRecorder.startRecording()
                    self.infoRec = "Stop"
                    
                }) {
                    Image(systemName: "circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 70, height: 70)
                        .clipped()
                        .foregroundColor(.red)
                }
            } else {
                Button(action: {
                    self.audioRecorder.stopRecording()
                    self.infoRec = "Registra"
                }) {
                    Image(systemName: "stop.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 70, height: 70)
                        .clipped()
                        .foregroundColor(.red)
                }
            }
            Divider()
            Text("\(infoRec)")
        }
        .navigationBarTitle(Text("Gestisci audio"))
    }
}

struct PreventCollapseView: View {

    private var mostlyClear = Color(UIColor(white: 0.0, alpha: 0.0005))

    var body: some View {
        Rectangle()
            .fill(mostlyClear)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 1)
    }
}

/*struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}*/
