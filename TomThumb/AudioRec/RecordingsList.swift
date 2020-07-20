//
//  RecordingsList.swift
//  TomThumb
//
//  Created by Marco Ortu on 18/07/2020.
//  Copyright © 2020 Sora. All rights reserved.
//

import SwiftUI

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
            GeometryReader { _ in
                Text("\(self.audioURL.lastPathComponent)")
                    .foregroundColor(self.selectedAudio.lastPathComponent == self.audioURL.lastPathComponent ? .green : .white)
                
            }.onTapGesture {
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

