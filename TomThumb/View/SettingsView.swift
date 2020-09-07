//
//  SettingsView.swift
//  TomThumb
//
//  Created by Marco Ortu on 13/07/2020.
//  Copyright © 2020 Sora. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseStorage

struct SettingsView: View {
    @State private var searchText = ""
    @State var showingAudioAlert = false
    @ObservedObject var audioRecorder = AudioRecorder()
    @State var selectedAudio = URL(fileURLWithPath: "")
    @State var audioName = ""
    @ObservedObject var audioPlayer = AudioPlayer()
    @State private var selectedFarAudio = 0
    @State private var selectedUnexpectedAudio = 0
    
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
                    NavigationLink(destination: Audio(showingAudioAlert: self.$showingAudioAlert, audioRecorder: self.audioRecorder, selectedAudio: self.selectedAudio, audioName: self.$audioName)) {
                        Text("Gestisci audio")
                    }
                }
                //selectedAudio.lastPathComponent
                Section(header: Text("Audio emergenze")) {
                    
                    NavigationLink(destination: AudioPickerFarFromCrumb(audioRecorder: audioRecorder)) {
                        HStack {
                            Text("Allontanamento")
                            Spacer()
                            Text("\(AudioRecorder.farFromCrumbURL.lastPathComponent)").foregroundColor(InterfaceConstants.secondaryInfoForegroundColor)
                        }
                    }
                    NavigationLink(destination: AudioPickerUnforseen(audioRecorder: audioRecorder)) {
                        HStack {
                            Text("Imprevisti")
                            Spacer()
                            Text("\(AudioRecorder.unforseenURL.lastPathComponent)").foregroundColor(InterfaceConstants.secondaryInfoForegroundColor)
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
            
        } .navigationBarTitle("Impostazioni", displayMode: .large)
            .accentColor(InterfaceConstants.genericLinkForegroundColor)
            .onAppear {
                //print("FETCH AUDIO")
                //fetchAudios()
        }
    }
    
}

struct AudioPickerFarFromCrumb: View {
    @ObservedObject var audioRecorder: AudioRecorder
    
    var body: some View {
        List {
            ForEach(AudioRecorder.recordings, id: \.createDate) { recording in
                AudioRowFarFromCrumb(audioURL: recording.fileURL)
                    .onTapGesture {
                        AudioRecorder.farFromCrumbURL = recording.fileURL
                        if AudioPlayer.player.isPlaying{
                            AudioPlayer.player.stopPlayback()
                        }
                        AudioPlayer.player.startPlayback(audio: recording.fileURL)
                }
            }
        }
    }
}

struct AudioRowFarFromCrumb: View {
    @ObservedObject var audioPlayer = AudioPlayer()
    @State var audioURL: URL
    
    var body: some View {
        HStack {
            Text(audioURL.lastPathComponent)
            Spacer()
            if AudioRecorder.farFromCrumbURL == audioURL {
                Image(systemName: "checkmark").foregroundColor(InterfaceConstants.genericLinkForegroundColor)
            }
        }
    }
}

struct AudioPickerUnforseen: View {
    @ObservedObject var audioRecorder: AudioRecorder
    
    var body: some View {
        List {
            ForEach(AudioRecorder.recordings, id: \.createDate) { recording in
                AudioRowUnforseen(audioURL: recording.fileURL)
                    .onTapGesture {
                        AudioRecorder.unforseenURL = recording.fileURL
                        if AudioPlayer.player.isPlaying{
                            AudioPlayer.player.stopPlayback()
                        }
                        AudioPlayer.player.startPlayback(audio: recording.fileURL)
                }
            }
        }
    }
}

struct AudioRowUnforseen: View {
    @ObservedObject var audioPlayer = AudioPlayer()
    @State var audioURL: URL
    
    var body: some View {
        HStack {
            Text(audioURL.lastPathComponent)
            Spacer()
            if AudioRecorder.unforseenURL == audioURL {
                Image(systemName: "checkmark").foregroundColor(InterfaceConstants.genericLinkForegroundColor)
            }
        }
    }
}


struct Audio: View {
    @Binding var showingAudioAlert: Bool
    @ObservedObject var audioRecorder: AudioRecorder
    @State var selectedAudio: URL
    @Binding var audioName: String
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
