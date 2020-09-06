//
//  RecordingsList.swift
//  TomThumb
//
//  Created by Marco Ortu on 18/07/2020.
//  Copyright © 2020 Sora. All rights reserved.
//

import SwiftUI
import Firebase

struct RecordingsList: View {
    
    @ObservedObject var audioRecorder: AudioRecorder
    @Binding var selectedAudio: URL
    
    var body: some View {
        List {
            ForEach(audioRecorder.recordings, id: \.createDate) { recording in
                RecordingRow(audioURL: recording.fileURL, selectedAudio: self.$selectedAudio)
            }
            .onDelete(perform: delete)
        }
    }
    
    func delete(at offsets: IndexSet) {
        var urlsToDelete = [URL]()
        self.selectedAudio = URL(fileURLWithPath: "")
        for index in offsets {
            urlsToDelete.append(audioRecorder.recordings[index].fileURL)
        }
        audioRecorder.deleteRecording(urlsToDelete: urlsToDelete)
    }
}

struct RecordingRow: View {
    var audioURL: URL
    @ObservedObject var audioPlayer = AudioPlayer()
    @Binding var selectedAudio: URL
    
    var body: some View {
        HStack {
            Image(systemName: "mic.fill")
            GeometryReader { _ in
                Text("\(self.audioURL.lastPathComponent)")
                    .foregroundColor(self.selectedAudio.lastPathComponent == self.audioURL.lastPathComponent ? .green : .white)
                    .frame(width: (UIScreen.main.bounds.size.width/100) * 60, height: 30, alignment: .leading)
            }.frame(width: (UIScreen.main.bounds.size.width/100) * 60, height: 30, alignment: .leading)
            .onTapGesture {
                self.selectedAudio = self.audioURL
            }
            Spacer()
            if audioPlayer.isPlaying == false {
                Button(action: {
                    self.audioPlayer.startPlayback(audio: self.audioURL)
                }) {
                    Image(systemName: "play.circle")
                        .imageScale(.large)
                }
            } else {
                Button(action: {
                    self.audioPlayer.stopPlayback()
                }) {
                    Image(systemName: "stop.circle.fill")
                        .imageScale(.large)
                }
            }
        }
    }
}

struct RecordingsListSettings: View {
    
    @ObservedObject var audioRecorder: AudioRecorder
    @Binding var selectedAudio: URL
    @Binding var audioName: String
    
    var body: some View {
        List {
            ForEach(audioRecorder.recordings, id: \.createDate) { recording in
                RecordingRowSettings(audioURL: recording.fileURL, selectedAudio: self.$selectedAudio, audioName: self.$audioName)
            }
            .onDelete(perform: delete)
        }
    }
    
    func delete(at offsets: IndexSet) {
        // elimina audio in locale
        var urlsToDelete = [URL]()
        self.selectedAudio = URL(fileURLWithPath: "")
        for index in offsets {
            urlsToDelete.append(audioRecorder.recordings[index].fileURL)
        }
        audioRecorder.deleteRecording(urlsToDelete: urlsToDelete)
    }
}

struct RecordingRowSettings: View {
    @State var audioURL: URL
    @ObservedObject var audioPlayer = AudioPlayer()
    @Binding var selectedAudio: URL
    @Binding var audioName: String
    
    var body: some View {
        HStack {
            Image(systemName: "mic.fill")
            NavigationLink(destination: ChangeAudioName(audioName: self.audioURL.lastPathComponent, audioURL: self.audioURL)) {
                VStack {
                    Text("\(self.audioURL.lastPathComponent)")
                }
            }
            /*.frame(width: (UIScreen.main.bounds.size.width/100) * 60, height: 30, alignment: .leading)*/
            .onTapGesture {
                self.selectedAudio = self.audioURL
            }
            Spacer()
            if audioPlayer.isPlaying == false {
                Button(action: {
                    self.audioPlayer.startPlayback(audio: self.audioURL)
                }) {
                    Image(systemName: "play.circle")
                        .imageScale(.large)
                }
            } else {
                Button(action: {
                    self.audioPlayer.stopPlayback()
                }) {
                    Image(systemName: "stop.circle.fill")
                        .imageScale(.large)
                }
            }
        }
    }
}

struct ChangeAudioName: View {
    @State var audioName = ""
    @State var audioURL: URL
    @State var isEditing = false

    var body: some View {
        Form {
            Section(header: Text("Modifica nome")) {
                ZStack(alignment: .trailing) {
                    TextField("Name", text: $audioName, onEditingChanged: {_ in self.isEditing = true
                        print("Audio name in text field: \(self.audioName)")
                    })
                    Button(action: {
                        self.audioName = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                            .opacity((!self.isEditing || self.audioName == "") ? 0 : 1)
                    }
                }
                
            }
        }
        .navigationBarTitle(Text("Nome"), displayMode: .inline)
        .onDisappear(perform: updateAudio)
    }
    // TEST non funziona la rinomina di un audio 
    func updateAudio() {
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let store = Storage.storage()
        //init metadata per storage
        let metadata = StorageMetadata()
        metadata.contentType = "audio/x-m4a"
        let pathString = "\(self.audioURL.lastPathComponent)"
        let storeRef = store.reference().child("audio/\(pathString)")
        
        //Elimino vecchio audio
        storeRef.delete { error in
           if let error = error {
                print(error.localizedDescription)
           } else {
           // File eliminato 
           }
        }
        self.audioURL = documentPath.appendingPathComponent(self.audioName)
        let fileUrls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        guard let fileUrl = fileUrls.first?.appendingPathComponent(self.audioName) else {
            return
        }
        let audioRenamed = URL(string: "file:///private/\(fileUrl.absoluteString.dropFirst(8))")
        print("AUDIO RENAMED: \(audioRenamed!)")
        let storeRefNew = store.reference().child("audio/\(audioURL.lastPathComponent)")
        // Upload audio rinominato
        let _ = storeRefNew.putFile(from: audioURL, metadata: metadata) { (metadata, error) in
            guard let _ = metadata else {
                print("error occurred: \(error.debugDescription)")
                return
            }
        }

        
        print("Audio name: \(self.audioName)")
        print("Audio settings: \(self.audioURL)")
    }
}

struct RecordingsList_Previews: PreviewProvider {
    @State static var url = URL(fileURLWithPath: "start.m4a")
    static var previews: some View {
        RecordingsList(audioRecorder: AudioRecorder(), selectedAudio: $url)
    }
}
