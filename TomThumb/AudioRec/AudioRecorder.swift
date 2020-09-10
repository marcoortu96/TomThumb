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
import Firebase
import FirebaseStorage

// Model for audio recorder
class AudioRecorder: NSObject, ObservableObject {
    let objectWillChange = PassthroughSubject<AudioRecorder, Never>()
    @Published var audioRecorder: AVAudioRecorder!
    static var recordings = [Recording]()
    static var defaultRecordings = [Recording]()
    static var farFromCrumbURL = URL(fileURLWithPath: "")
    static var unforseenURL = URL(fileURLWithPath: "")
    /*let defaultRecordings = [Recording(fileURL: URL(fileURLWithPath: Bundle.main.path(forResource: "start1.m4a", ofType: nil)!), createDate: Date(timeIntervalSince1970: TimeInterval(exactly: 0)!)),
                             Recording(fileURL: URL(fileURLWithPath: Bundle.main.path(forResource: "crumb1.m4a", ofType: nil)!), createDate: Date(timeIntervalSince1970: TimeInterval(exactly: 1)!)),
                             Recording(fileURL: URL(fileURLWithPath: Bundle.main.path(forResource: "finish1.m4a", ofType: nil)!), createDate: Date(timeIntervalSince1970: TimeInterval(exactly: 2)!)),
                             Recording(fileURL: URL(fileURLWithPath: Bundle.main.path(forResource: "farFromCrumb.m4a", ofType: nil)!), createDate: Date(timeIntervalSince1970: TimeInterval(exactly: 3)!))]
 */
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
        
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let audioFilename = documentPath.appendingPathComponent("\(Date().toString(dateFormat: "dd-MM-YY'at'_HH:mm:ss")).m4a")
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
        AudioRecorder.recordings.removeAll()
        AudioRecorder.defaultRecordings.removeAll()
        let audioDefaultName = ["Inizio percorso.m4a", "Briciola raccolta.m4a", "Fine percorso.m4a", "Allontanamento.m4a", "Imprevisto.m4a"]
        
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryContents = try! fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
        
        for audio in directoryContents {
            let recording = Recording(fileURL: audio, createDate: getCreationDate(for: audio))
            if audioDefaultName.contains(audio.lastPathComponent) {
                AudioRecorder.defaultRecordings.append(recording)
            } else {
                AudioRecorder.recordings.append(recording)
            }
        }
        
        AudioRecorder.defaultRecordings.sort(by: {$0.fileURL.lastPathComponent.compare($1.fileURL.lastPathComponent) == .orderedDescending})
        AudioRecorder.recordings.sort(by: {$0.createDate.compare($1.createDate) == .orderedDescending})
        //recordings = defaultRecordings + recordings
        
        // Store degli audio presenti in recordings nello storage
        let store = Storage.storage()
        
        //init metadata per storage
        let metadata = StorageMetadata()
        metadata.contentType = "audio/x-m4a"
        
        for record in AudioRecorder.recordings {
            let storeRef = store.reference().child("audio/\(record.fileURL.lastPathComponent)")
            // Upload audio
            let _ = storeRef.putFile(from: record.fileURL, metadata: metadata) { (metadata, error) in
                guard let _ = metadata else {
                    print("error occurred: \(error.debugDescription)")
                    return
                }
            }
        }
        
        objectWillChange.send(self)
    }
    
    func deleteRecording(urlsToDelete: [URL]) {
        for url in urlsToDelete {
            print("urlRec: \(url)")
            do {
                // elimino audio in locale
                try FileManager.default.removeItem(at: url)
                
                // elimina audio da storage
                let store = Storage.storage()
                let storeRef = store.reference().child("audio/\(url.lastPathComponent)")
                
                //Elimino vecchio audio
                storeRef.delete { error in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        // File eliminato
                    }
                }
                
            } catch {
                print("il file non può essere cancellato")
            }
        }
        fetchRecordings()
    }
}

// Struct of a recording object
class Recording: ObservableObject{
    @Published var fileURL: URL
    var createDate: Date
    
    init(fileURL: URL, createDate: Date) {
        self.fileURL = fileURL
        self.createDate = createDate
    }
    
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
