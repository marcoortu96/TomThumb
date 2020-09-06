//
//  RecordingsList.swift
//  TomThumb
//
//  Created by Marco Ortu on 18/07/2020.
//  Copyright © 2020 Sora. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseStorage

struct RecordingsList: View {
    
    @ObservedObject var audioRecorder: AudioRecorder
    @Binding var selectedAudio: URL
    
    var body: some View {
        List {
            ForEach(AudioRecorder.recordings, id: \.createDate) { recording in
                RecordingRow(audioURL: recording.fileURL, selectedAudio: self.$selectedAudio)
            }
            .onDelete(perform: delete)
        }
    }
    
    func delete(at offsets: IndexSet) {
        var urlsToDelete = [URL]()
        self.selectedAudio = URL(fileURLWithPath: "")
        for index in offsets {
            urlsToDelete.append(AudioRecorder.recordings[index].fileURL)
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
                    if AudioPlayer.player.isPlaying {
                        AudioPlayer.player.stopPlayback()
                    }
                    AudioPlayer.player.startPlayback(audio: self.audioURL)
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
            ForEach(AudioRecorder.recordings, id: \.createDate) { recording in
                RecordingRowSettings(audioURL: recording.fileURL, selectedAudio: self.$selectedAudio, audioName: self.audioName)
            }
            .onDelete(perform: delete)
        }
    }
    
    func delete(at offsets: IndexSet) {
        // elimina audio in locale
        var urlsToDelete = [URL]()
        self.selectedAudio = URL(fileURLWithPath: "")
        for index in offsets {
            urlsToDelete.append(AudioRecorder.recordings[index].fileURL)
        }
        audioRecorder.deleteRecording(urlsToDelete: urlsToDelete)
    }
}

struct RecordingRowSettings: View {
    @State var audioURL: URL
    @ObservedObject var audioPlayer = AudioPlayer()
    @Binding var selectedAudio: URL
    @State var audioName: String
    
    var body: some View {
        HStack {
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
            Spacer()
            NavigationLink(destination: ChangeAudioName(audioName: self.audioURL.lastPathComponent, audioURL: self.audioURL)) {
                VStack {
                    Text("\(self.audioURL.lastPathComponent)")
                }
            }
                /*.frame(width: (UIScreen.main.bounds.size.width/100) * 60, height: 30, alignment: .leading)*/
                .onTapGesture {
                    self.selectedAudio = self.audioURL
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
        .onDisappear {
            self.updateAudio()
        }
    }
    
    // TEST non funziona la rinomina di un audio 
    func updateAudio() {
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
                print("file eliminato")
            }
        }
        do {
            let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let documentDirectory = URL(fileURLWithPath: documentPath)
            let originPath = documentDirectory.appendingPathComponent(audioURL.lastPathComponent)
            let destinationPath = documentDirectory.appendingPathComponent(self.audioName + ".m4a")
            try FileManager.default.moveItem(at: originPath, to: destinationPath)
            
            print(originPath)
            print(destinationPath)
            /*
             //self.audioURL = documentPath.appendingPathComponent(self.audioName)
             let fileUrls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
             guard let fileUrl = fileUrls.first?.appendingPathComponent(self.audioName) else {
             return
             }
             
             let audioRenamed = URL(string: "file:///private/\(fileUrl.absoluteString.dropFirst(8))")
             
             FileManager.moveItem(<#T##self: FileManager##FileManager#>)
             
             print("SiAMO QUI \(fileUrl.absoluteString.dropLast(fileUrl.lastPathComponent.count) + audioRenamed!.lastPathComponent)")
             //print("AUDIO RENAMED: \(audioRenamed!)") */
            let storeRefNew = store.reference().child("audio/\(destinationPath.lastPathComponent)")
            // Upload audio rinominato
            let uploadTask = storeRefNew.putFile(from: destinationPath, metadata: metadata) { (metadata, error) in
                guard let _ = metadata else {
                    print("error occurred: \(error.debugDescription)")
                    return
                }
            }
            
            uploadTask.observe(.progress) { snapshot in
                let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
                print("percentComplete \(percentComplete)")
            }

            uploadTask.observe(.success) { snapshot in
                print("uploadTask success")
            }
            //var audioRecorder = AudioRecorder()
            //AudioRecorder.recordings = []
            
        } catch {
            print(error.localizedDescription)
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
