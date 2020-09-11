//
//  RecordingsList.swift
//  TomThumb
//
//  Created by Marco Ortu on 18/07/2020.
//  Copyright © 2020 Sora. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseDatabase
import FirebaseStorage

struct RecordingsList: View {
    
    @ObservedObject var audioRecorder: AudioRecorder
    @Binding var selectedAudio: URL
    @State var showingLoadingView = false
    
    var body: some View {
        
        List {
            ForEach(AudioRecorder.defaultRecordings + AudioRecorder.recordings, id: \.createDate) { recording in
                RecordingRow(audioURL: recording.fileURL, selectedAudio: self.$selectedAudio)
            }
        }
        
    }
}

struct RecordingRow: View {
    var audioURL: URL
    @ObservedObject var audioPlayer = AudioPlayer.player
    @Binding var selectedAudio: URL
    
    var body: some View {
        HStack {
            Image(systemName: "mic.fill")
            GeometryReader { _ in
                Text("\(String(self.audioURL.lastPathComponent.prefix(self.audioURL.lastPathComponent.count-4)))")
                    .foregroundColor(self.selectedAudio.lastPathComponent == self.audioURL.lastPathComponent ? .green : .white)
                    .frame(width: (UIScreen.main.bounds.size.width/100) * 60, height: 30, alignment: .leading)
            }.frame(width: (UIScreen.main.bounds.size.width/100) * 60, height: 30, alignment: .leading)
                .onTapGesture {
                    self.selectedAudio = self.audioURL
            }
            Spacer()
            if !audioPlayer.isPlaying {
                Button(action: {
                    if self.audioPlayer.isPlaying {
                        self.audioPlayer.stopPlayback()
                    }
                    self.audioPlayer.startPlayback(audio: self.audioURL)
                }) {
                    Image(systemName: "play.circle")
                        .imageScale(.large)
                }
            } else if audioPlayer.audioPlayer.url! == self.audioURL {
                Button(action: {
                    self.audioPlayer.stopPlayback()
                }) {
                    Image(systemName: "stop.circle.fill")
                        .imageScale(.large)
                }
            } else {
                Button(action: {
                    self.audioPlayer.stopPlayback()
                }) {
                    Image(systemName: "play.circle")
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
    @Binding var audios: [Recording]
    @Binding var defaultAudios: [Recording]
    @State var showingActivityIndicator = false
    var audioDefaultName = ["Inizio percorso.m4a", "Briciola raccolta.m4a", "Fine percorso.m4a", "Allontanamento.m4a", "Imprevisto.m4a"]
    
    var body: some View {
        Form {
            Section(header: Text("Audio default").font(.body).bold())  {
                ForEach(self.defaultAudios, id: \.createDate) { recording in
                    RecordingRowSettings(audioURL: recording.fileURL, selectedAudio: self.$selectedAudio, audioName: self.audioName, audios: self.$audios, defaultAudios: self.$defaultAudios ,showingActivityIndicator: self.$showingActivityIndicator)
                }
            }
            Section(header: Text("I miei audio").font(.body).bold()){
                ForEach(self.audios, id: \.createDate) { recording in
                    RecordingRowSettings(audioURL: recording.fileURL, selectedAudio: self.$selectedAudio, audioName: self.audioName, audios: self.$audios, defaultAudios: self.$defaultAudios, showingActivityIndicator: self.$showingActivityIndicator)
                }.onDelete(perform: self.delete)
                
            }
        }
        .listStyle(GroupedListStyle())
        .environment(\.horizontalSizeClass, .regular)
        .onAppear {
            self.audios = AudioRecorder.recordings
            self.defaultAudios = AudioRecorder.defaultRecordings
        }
        
    }
    
    
    
    func delete(at offsets: IndexSet) {
        // elimina audio in locale
        var urlsToDelete = [URL]()
        self.selectedAudio = URL(fileURLWithPath: "")
        
        for index in offsets {
            urlsToDelete.append(AudioRecorder.recordings[index].fileURL)
            print("urlsToDelete: \(urlsToDelete)")
        }
        audioRecorder.deleteRecording(urlsToDelete: urlsToDelete)
        self.audios.remove(atOffsets: offsets)
    }
}

struct RecordingRowSettings: View {
    @State var audioURL: URL
    @ObservedObject var audioPlayer = AudioPlayer.player
    @Binding var selectedAudio: URL
    @State var audioName: String
    @Binding var audios: [Recording]
    @Binding var defaultAudios: [Recording]
    @Binding var showingActivityIndicator: Bool
    var audioDefaultName = ["Inizio percorso.m4a", "Briciola raccolta.m4a", "Fine percorso.m4a", "Allontanamento.m4a", "Imprevisto.m4a"]
    
    var body: some View {
        HStack {
            if !audioPlayer.isPlaying {
                Button(action: {
                    if self.audioPlayer.isPlaying {
                        self.audioPlayer.stopPlayback()
                    }
                    self.audioPlayer.startPlayback(audio: self.audioURL)
                }) {
                    Image(systemName: "play.circle")
                        .imageScale(.large)
                }.buttonStyle(BorderlessButtonStyle())
            } else if audioPlayer.audioPlayer.url! == self.audioURL{
                Button(action: {
                    self.audioPlayer.stopPlayback()
                }) {
                    Image(systemName: "stop.circle.fill")
                        .imageScale(.large)
                }.buttonStyle(BorderlessButtonStyle())
            } else {
                Button(action: {
                    self.audioPlayer.stopPlayback()
                }) {
                    Image(systemName: "play.circle")
                        .imageScale(.large)
                }.buttonStyle(BorderlessButtonStyle())
            }
            if self.audioDefaultName.contains(self.audioURL.lastPathComponent) {
                VStack(alignment: .leading) {
                    Text("\(self.audioURL.lastPathComponent)")
                }
            } else {
                NavigationLink(destination: ChangeAudioName(audioName: self.audioURL.lastPathComponent, audioURL: self.audioURL, audios: self.$audios, defaultAudios: self.$defaultAudios ,showingActivityIndicator: self.$showingActivityIndicator)) {
                    VStack {
                        Text("\(self.audioURL.lastPathComponent)")
                    }
                }.buttonStyle(BorderlessButtonStyle())
                    .onTapGesture {
                        self.selectedAudio = self.audioURL
                }
            }
        }
    }
}

struct ChangeAudioName: View {
    @State var audioName = ""
    @State var audioURL: URL
    @State var isEditing = false
    @Binding var audios: [Recording]
    @Binding var defaultAudios: [Recording]
    @Binding var showingActivityIndicator: Bool
    let audioDefaultName = ["Inizio percorso.m4a", "Briciola raccolta.m4a", "Fine percorso.m4a", "Allontanamento.m4a", "Imprevisto.m4a"]
    
    var body: some View {
        LoadingView(isShowing: self.$showingActivityIndicator, string: "Connessione") {
            
            
            Form {
                Section(header: Text("Modifica nome")) {
                    ZStack(alignment: .trailing) {
                        TextField("Name", text: self.$audioName, onEditingChanged: {_ in
                            self.isEditing = true
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
        }
        .navigationBarTitle(Text("Nome"), displayMode: .inline)
        .onDisappear {
            self.updateAudio()
        }
        .onAppear {
            self.checkConnection()
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
    
    // Rinomina degli audio
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
                do {
                    let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
                    let documentDirectory = URL(fileURLWithPath: documentPath)
                    let originPath = documentDirectory.appendingPathComponent(self.audioURL.lastPathComponent)
                    let destinationPath = documentDirectory.appendingPathComponent("\(self.audioName).m4a")
                    try FileManager.default.moveItem(at: originPath, to: destinationPath)
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
                        self.audios = []
                        self.defaultAudios = []
                        self.reloadAudios()
                        self.showingActivityIndicator = false
                    }
                    
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        
    }
    
    func reloadAudios() {
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
                
                AudioRecorder.recordings.removeAll()
                directoryContents.removeAll()
                if !directoryContents.contains(check!) {
                    let downloadTask = storageRef.child(r.name).write(toFile: fileUrl)
                    downloadTask.observe(.success) { _ in
                        if self.audioDefaultName.contains(r.name) {
                            self.defaultAudios.append(Recording(fileURL: fileUrl, createDate: getCreationDate(for: fileUrl)))
                            
                        } else {
                            AudioRecorder.recordings.append(Recording(fileURL: fileUrl, createDate: getCreationDate(for: fileUrl)))
                            self.audios.append(Recording(fileURL: fileUrl, createDate: getCreationDate(for: fileUrl)))
                        }
                    }
                }
                
                // Assegno audio di default a allontanamento
                if r.name == "Allontanamento.m4a" {
                    AudioRecorder.farFromCrumbURL = check!
                }
                
                // Assegno audio di default a imprevisti
                if r.name == "Imprevisto.m4a" {
                    AudioRecorder.unforseenURL = check!
                }
                
            }
        }
    }
    
}

// Fetch degli audio
func fetchAudios() {
    let storage = Storage.storage()
    let storageRef = storage.reference().child("audio")
    let fileUrls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let audioDefaultName = ["Inizio percorso.m4a", "Briciola raccolta.m4a", "Fine percorso.m4a", "Allontanamento.m4a", "Imprevisto.m4a"]
    
    let directoryContents = try! FileManager.default.contentsOfDirectory(at: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0], includingPropertiesForKeys: nil)
    
    storageRef.listAll { (result, error) in
        for r in result.items {
            guard let fileUrl = fileUrls.first?.appendingPathComponent(r.name) else {
                return
            }
            let check = URL(string: "file:///private/\(fileUrl.absoluteString.dropFirst(8))")
            
            // Assegno audio di default a Allontanamento
            if r.name == "Allontanamento.m4a" {
                AudioRecorder.farFromCrumbURL = check!
            }
            
            // Assegno audio di default a Imprevisti
            if r.name == "Imprevisto.m4a" {
                AudioRecorder.unforseenURL = check!
            }
            
            if directoryContents.contains(check!) {
                let downloadTask = storageRef.child(r.name).write(toFile: fileUrl)
                downloadTask.observe(.success) { _ in
                    print(audioDefaultName.contains(r.name))
                    if audioDefaultName.contains(r.name) {
                        AudioRecorder.defaultRecordings.append(Recording(fileURL: fileUrl, createDate: getCreationDate(for: fileUrl)))
                    } else {
                        AudioRecorder.recordings.append(Recording(fileURL: fileUrl, createDate: getCreationDate(for: fileUrl)))
                    }
                    
                }
            }
            
        }
    }
}

struct RecordingsList_Previews: PreviewProvider {
    @State static var url = URL(fileURLWithPath: "start.m4a")
    static var previews: some View {
        RecordingsList(audioRecorder: AudioRecorder(), selectedAudio: $url)
    }
}
