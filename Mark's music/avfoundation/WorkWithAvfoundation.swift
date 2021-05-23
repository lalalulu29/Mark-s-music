//
//  WorkWithAvfoundation.swift
//  Mark's music
//
//  Created by Кирилл Любарских  on 22.04.2021.
//

import AVFoundation
import UIKit


class WorkWithAVFoundation {

    private var AVPlayer = AVAudioPlayer()
    func readyPlaySong(songData: Data) -> AVAudioPlayer? {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            AVPlayer = try AVAudioPlayer(data: songData)
            
            return AVPlayer
        } catch {
            print("error")
            return nil
        }
    }
    

}
