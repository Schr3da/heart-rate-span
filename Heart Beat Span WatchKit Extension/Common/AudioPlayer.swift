//
//  AudioPlayer.swift
//  Heart Beat Span WatchKit Extension
//
//  Created by schr3da on 09.10.19.
//  Copyright © 2019 schreda. All rights reserved.
//

import Foundation
import AVFoundation

enum HBSSound: String {
    case UpperLimit = "upper-limit.mp3"
    case LowerLimit = "lower-limit.mp3"
}

class AudioPlayer {
    
    private var muted: Bool = false
    private var player: AVAudioPlayer = AVAudioPlayer()
    
    private func getFile(filename: String) -> URL {
        let path = Bundle.main.path(forResource: filename, ofType:nil)!
        let url = URL(fileURLWithPath: path)
        return url
    }
    
    private func setMuted(_ muted: Bool) {
        self.muted = muted
    }
    
    func play(sound: String) {
        do {
            let url = getFile(filename: sound);
            player = try AVAudioPlayer(contentsOf: url)
            player.play()
        } catch {
            print("Unable to play audio file")
        }
    }
    
    func stop() {
        if player.isPlaying == false {
            return
        }
        player.stop()
     }
}



