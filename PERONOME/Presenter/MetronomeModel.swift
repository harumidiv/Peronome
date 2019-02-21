//
//  MetronomeModel.swift
//  PERONOME
//
//  Created by 佐川晴海 on 2019/02/22.
//  Copyright © 2019 佐川　晴海. All rights reserved.
//

import Foundation
import AVFoundation

class MetronomeModel{
    var audio: AVAudioPlayer?

    func loadAudio(){
        let path = Bundle.main.path(forResource: "metronomeSound", ofType: "mp4")
        let url = URL(fileURLWithPath: path!)
        do { try  audio = AVAudioPlayer(contentsOf: url) }
        catch{ fatalError() }
        audio?.prepareToPlay()
    }
    func stopAudio(){
        audio?.stop()
        audio?.currentTime = 0
    }
    func playAudio(){
        audio?.play()
    }
    
}
