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

    func loadAudio(){
        // マナーモード中でも鳴らす
        try? AVAudioSession.sharedInstance().setCategory(.playback, options: .mixWithOthers)
        try? AVAudioSession.sharedInstance().setActive(true)

        guard audio == nil else { return }
        let path = Bundle.main.path(forResource: "sound4", ofType: "mp3")
        let url = URL(fileURLWithPath: path!)
        do { try  audio = AVAudioPlayer(contentsOf: url) }
        catch{ fatalError() }
        audio?.prepareToPlay()
    }

    func stopAudio(){
        audio?.stop()
        audio?.currentTime = 0
    }

    func playAudio(volume: Float = 1.0){
        stopAudio()
        audio?.volume = volume
        audio?.play()
    }

}
