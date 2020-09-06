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
                    
                    NavigationLink(destination: AudioPicker(audioRecorder: audioRecorder, selectedAudio: $selectedAudio)) {
                        HStack {
                            Text("Allonamento")
                            Spacer()
                            Text("\(self.selectedAudio.lastPathComponent)").foregroundColor(InterfaceConstants.secondaryInfoForegroundColor)
                        }
                    }
                    
                    
                    Picker(selection: $selectedUnexpectedAudio, label: Text("Imprevisti")) {
                        ForEach(0 ..< AudioRecorder.recordings.count) {
                            Text("\(AudioRecorder.recordings[$0].fileURL.lastPathComponent)")
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
                print("FETCH AUDIO")
                self.fetchAudios()
        }
    }
    

    func fetchAudios() {
        let storage = Storage.storage()
        let storageRef = storage.reference().child("audio")
        let fileUrls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        var directoryContents = try! FileManager.default.contentsOfDirectory(at: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0], includingPropertiesForKeys: nil)
        
        storageRef.listAll { (result, error) in
            for r in result.items {
                guard let fileUrl = fileUrls.first?.appendingPathComponent(r.name) else {
                    return
                }
                let check = URL(string: "file:///private/\(fileUrl.absoluteString.dropFirst(8))")
                if !directoryContents.contains(check!) {
                    let downloadTask = storageRef.child(r.name).write(toFile: fileUrl)
                    AudioRecorder.recordings.append(Recording(fileURL: fileUrl, createDate: getCreationDate(for: fileUrl)))
                   downloadTask.observe(.success) { _ in
                        print("file scaricato")
                        AudioRecorder.recordings.append(Recording(fileURL: fileUrl, createDate: getCreationDate(for: fileUrl)))
                   }
                }
                
            }
        }
    }
}

struct AudioPicker: View {
    @ObservedObject var audioRecorder: AudioRecorder
    @Binding var selectedAudio: URL
    
    var body: some View {
        List {
            ForEach(AudioRecorder.recordings, id: \.createDate) { recording in
                AudioRow(audioURL: recording.fileURL, selectedAudio: self.$selectedAudio)
                    .onTapGesture {
                        self.selectedAudio = recording.fileURL
                        if AudioPlayer.player.isPlaying{
                            AudioPlayer.player.stopPlayback()
                        }
                        AudioPlayer.player.startPlayback(audio: recording.fileURL)
                }
            }
        }
    }
}

struct AudioRow: View {
    @ObservedObject var audioPlayer = AudioPlayer()
    @State var audioURL: URL
    @State var checked = false
    @Binding var selectedAudio: URL
    
    var body: some View {
        HStack {
            Text(audioURL.lastPathComponent)
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
