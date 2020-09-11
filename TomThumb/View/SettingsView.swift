//
//  SettingsView.swift
//  TomThumb
//
//  Created by Marco Ortu on 13/07/2020.
//  Copyright © 2020 Sora. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseDatabase
import FirebaseStorage

struct SettingsView: View {
    @State private var searchText = ""
    @State var showingAudioAlert = false
    @ObservedObject var audioRecorder = AudioRecorder()
    @State var audioName = ""
    @ObservedObject var audioPlayer = AudioPlayer()
    @State var selectedFarFromCrumb = URL(fileURLWithPath: "")
    @State var selectedUnforseen = URL(fileURLWithPath: "")
    
    var body: some View {
        VStack {
            PreventCollapseView()
            Form {
                Section(header: Text("Profilo").font(.body).bold()) {
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
                Section(header: Text("Audio").font(.body).bold()) {
                    HStack {
                        Image(systemName: "pencil.circle.fill").foregroundColor(Color.blue).font(.title)
                        NavigationLink(destination: Audio(showingAudioAlert: self.$showingAudioAlert, audioRecorder: self.audioRecorder, audioName: self.$audioName)) {
                            Text("Gestisci audio")
                        }
                    }
                }
                Section(header: Text("Audio emergenze").font(.body).bold()) {
                    
                    NavigationLink(destination: AudioPickerFarFromCrumb(audioRecorder: audioRecorder, selectedAudio: self.$selectedFarFromCrumb)) {
                        HStack {
                            Image(systemName: "arrowtriangle.up.circle.fill").foregroundColor(Color.red).font(.title)
                            Text("Allontanamento")
                            Spacer()
                            Text("\(self.selectedFarFromCrumb.lastPathComponent)").frame(width: UIScreen.main.bounds.width / 4, height: 20, alignment: .trailing).foregroundColor(InterfaceConstants.secondaryInfoForegroundColor)
                        }
                    }
                    
                    NavigationLink(destination: AudioPickerUnforseen(audioRecorder: audioRecorder, selectedAudio: self.$selectedUnforseen)) {
                        HStack {
                            Image(systemName: "person.circle.fill").foregroundColor(Color.yellow).font(.title)
                            Text("Imprevisti")
                            Spacer()
                            Text("\(self.selectedUnforseen.lastPathComponent)").frame(width: UIScreen.main.bounds.width / 4, height: 20, alignment: .trailing)
                                .foregroundColor(InterfaceConstants.secondaryInfoForegroundColor)
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
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
            
        } .navigationBarTitle("Impostazioni", displayMode: .large)
            .accentColor(InterfaceConstants.genericLinkForegroundColor)
            .onAppear {
                self.selectedUnforseen = AudioRecorder.unforseenURL
                self.selectedFarFromCrumb = AudioRecorder.farFromCrumbURL
        }
    }
    
}

struct AudioPickerFarFromCrumb: View {
    @ObservedObject var audioRecorder: AudioRecorder
    @Binding var selectedAudio: URL
    
    var body: some View {
        VStack {
            List {
                ForEach(AudioRecorder.defaultRecordings + AudioRecorder.recordings, id: \.createDate) { recording in
                    AudioRowFarFromCrumb(audioURL: recording.fileURL, selectedAudio: self.$selectedAudio)
                        .onTapGesture {
                            AudioRecorder.farFromCrumbURL = recording.fileURL
                            self.selectedAudio = recording.fileURL
                            if AudioPlayer.player.isPlaying{
                                AudioPlayer.player.stopPlayback()
                            }
                            AudioPlayer.player.startPlayback(audio: recording.fileURL)
                    }
                }
            }
            Text("Seleziona un audio da riprodurre quando l'assistito si allontana dal percorso")
                .foregroundColor(InterfaceConstants.secondaryInfoForegroundColor)
                .multilineTextAlignment(.center)
                .padding(.bottom, 15)
        }.navigationBarTitle("Allontanamento", displayMode: .inline)
    }
}

struct AudioRowFarFromCrumb: View {
    @ObservedObject var audioPlayer = AudioPlayer()
    @State var audioURL: URL
    @Binding var selectedAudio: URL
    
    var body: some View {
        HStack {
            Text(self.audioURL.lastPathComponent)
            Spacer()
            if selectedAudio == audioURL {
                Image(systemName: "checkmark").foregroundColor(InterfaceConstants.genericLinkForegroundColor)
            }
        }
    }
}

struct AudioPickerUnforseen: View {
    @ObservedObject var audioRecorder: AudioRecorder
    @Binding var selectedAudio: URL
    
    var body: some View {
        VStack {
            List {
                ForEach(AudioRecorder.defaultRecordings + AudioRecorder.recordings, id: \.createDate) { recording in
                    AudioRowUnforseen(audioURL: recording.fileURL, selectedAudio: self.$selectedAudio)
                        .onTapGesture {
                            AudioRecorder.unforseenURL = recording.fileURL
                            self.selectedAudio = recording.fileURL
                            if AudioPlayer.player.isPlaying{
                                AudioPlayer.player.stopPlayback()
                            }
                            AudioPlayer.player.startPlayback(audio: recording.fileURL)
                    }
                }
            }
            Text("Seleziona un audio da riprodurre quando l'assistito incontra uno sconosciuto")
                .foregroundColor(InterfaceConstants.secondaryInfoForegroundColor)
                .multilineTextAlignment(.center)
                .padding(.bottom, 15)
        }.navigationBarTitle("Imprevisto", displayMode: .inline)
    }
}

struct AudioRowUnforseen: View {
    @ObservedObject var audioPlayer = AudioPlayer()
    @State var audioURL: URL
    @Binding var selectedAudio: URL
    
    var body: some View {
        HStack {
            Text(self.audioURL.lastPathComponent)
            Spacer()
            if selectedAudio == audioURL {
                Image(systemName: "checkmark").foregroundColor(InterfaceConstants.genericLinkForegroundColor)
            }
        }
    }
}


struct Audio: View {
    @Binding var showingAudioAlert: Bool
    @ObservedObject var audioRecorder: AudioRecorder
    @State var selectedAudio = URL(fileURLWithPath: "")
    @Binding var audioName: String
    @State var infoRec = "Registra"
    @State var showingActivityIndicator = false
    @State var audios = [Recording]()
    @State var defaultAudios = [Recording]()
    
    var body: some View {
        LoadingView(isShowing: $showingActivityIndicator, string: "Connessione") {
            VStack(alignment: .center) {
                RecordingsListSettings(audioRecorder: self.audioRecorder, selectedAudio: self.$selectedAudio, audioName: self.$audioName, audios: self.$audios, defaultAudios: self.$defaultAudios)
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
                        self.audios.insert(AudioRecorder.recordings.first!, at: 0)
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
                Text("\(self.infoRec)")
            }
        }
        .navigationBarTitle(Text("Gestisci audio"), displayMode: .inline)
        .onAppear {
            self.checkConnection()
            self.audios = AudioRecorder.recordings
        }
    }
    
    func checkConnection() {
        let connectedRef = Database.database().reference(withPath: ".info/connected")
        connectedRef.observe(.value, with: { snapshot in
            if let connected = snapshot.value as? Bool, connected {
                self.showingActivityIndicator = false
            } else {
                self.showingActivityIndicator = true
            }
        })
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
