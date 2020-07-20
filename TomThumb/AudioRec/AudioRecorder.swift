//
//  AudioRecorder.swift
//  TomThumb
//
//  Created by Marco Ortu on 18/07/2020.
//  Copyright © 2020 Sora. All rights reserved.
//

import Foundation
import SwiftUI
import AVFoundation
import Combine

// Model for audio recorder
class AudioRecorder: NSObject, ObservableObject {
    let objectWillChange = PassthroughSubject<AudioRecorder, Never>()
    var audioRecorder: AVAudioRecorder!
    var recordings = [Recording]()
    var recording = false {
        didSet {
            objectWillChange.send(self)
        }
    }
    
    override init() {
        super.init()
        fetchRecordings()
    }
    
    func startRecording() {
        let recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            print("Errore di setup nella sessione di recording")
        }
        
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFilename = documentPath.appendingPathComponent("\(Date().toString(dateFormat: "dd-MM-YY'at'_HH:mm")).m4a")
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
           audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.record()
            recording = true
        } catch {
            print("Non puoi iniziare la registrazione")
        }
    }
    
    func stopRecording() {
        audioRecorder.stop()
        recording = false
        fetchRecordings()
    }
    
    func fetchRecordings() {
        recordings.removeAll()
        recordings.append(Recording(fileURL: URL(fileURLWithPath: Bundle.main.path(forResource: "start.m4a", ofType: nil)!), createDate: Date(timeIntervalSince1970: TimeInterval(exactly: 1000)!)))
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryContents = try! fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
        
        for audio in directoryContents {
            let recording = Recording(fileURL: audio, createDate: getCreationDate(for: audio))
            recordings.append(recording)
        }
        
        recordings.sort(by: {$0.createDate.compare($1.createDate) == .orderedAscending})
        objectWillChange.send(self)
    }
    
    func deleteRecording(urlsToDelete: [URL]) {
        for url in urlsToDelete {
            print("urlRec: \(url)")
            do {
                try FileManager.default.removeItem(at: url)
            } catch {
                print("il file non può essere cancellato")
            }
        }
        fetchRecordings()
    }
}

// Struct of a recording object
struct Recording {
    let fileURL: URL
    let createDate: Date
}

func getCreationDate(for file: URL) -> Date {
    if let attributes = try? FileManager.default.attributesOfItem(atPath: file.path) as [FileAttributeKey: Any],
        let creationDate = attributes[FileAttributeKey.creationDate] as? Date {
        return creationDate
    } else {
        return Date()
    }
}

extension Date {
    func toString( dateFormat format  : String ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
