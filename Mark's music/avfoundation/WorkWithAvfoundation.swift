//
//  WorkWithAvfoundation.swift
//  Mark's music
//
//  Created by Кирилл Любарских  on 22.04.2021.
//

import AVKit
import AVFoundation
import MediaPlayer

var Player: AVAudioPlayer!

class WorkWithAVKit {

   
    func readyPlaySong(songData: Data) {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            Player = try AVAudioPlayer(data: songData)
        } catch {
            print("error")
        }
    }

    
    
    
    
}

