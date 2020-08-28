//
//  AudioPlayer.swift
//  TomThumb
//
//  Created by Marco Ortu on 18/07/2020.
//  Copyright © 2020 Sora. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import AVFoundation

class AudioPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {
    
    let objectWillChange = PassthroughSubject<AudioPlayer, Never>()
    var isPlaying = false {
        didSet {
            objectWillChange.send(self)
        }
    }
    var audioPlayer: AVAudioPlayer!
    static var player = AudioPlayer()
    
    func startPlayback(audio: URL) {
        let playbackSession = AVAudioSession.sharedInstance()
        
        do {
            try playbackSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } catch {
            print("Errore override audio port")
        }
        
        do {
            print("sto riproducendo \(audio.absoluteString)")
            audioPlayer = try AVAudioPlayer(contentsOf: audio)
            audioPlayer.delegate = self
            audioPlayer.play()
            isPlaying = true
        } catch {
            print("Errore durante la riproduzione")
        }
    }
    
    func stopPlayback() {
        audioPlayer.stop()
        isPlaying = false
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            isPlaying = false
        }
    }
}
