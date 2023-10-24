//
//  AudioPlayer.swift
//  Peronome
//
//  Created by 佐川 晴海 on 2023/10/24.
//

import Foundation
import AVFoundation

final class AudioPlayer {
    private var audio: AVAudioPlayer?
    private var tempo: Int
    var speed:Double {
        return Double(tempo)
    }

    init(tempo: Int) {
        self.tempo = tempo
    }

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

    func addTempo() -> Int {
        if tempo >= 240 {
            return tempo
        }
        tempo += 1
        return tempo
    }

    func subTempo() -> Int{
        if tempo <= 40 {
            return tempo
        }
        tempo -= 1
        return tempo
    }

}
