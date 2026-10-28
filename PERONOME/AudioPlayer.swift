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
    // AVAudioSession・AVAudioPlayer の操作はメインスレッドをブロックしうるため専用キューで行う
    private let queue = DispatchQueue(label: "Peronome.AudioPlayer", qos: .userInteractive)

    func loadAudio(){
        queue.async { [self] in
            guard audio == nil else { return }

            // マナーモード中でも鳴らす
            try? AVAudioSession.sharedInstance().setCategory(.playback, options: .mixWithOthers)
            try? AVAudioSession.sharedInstance().setActive(true)

            let path = Bundle.main.path(forResource: "sound4", ofType: "mp3")
            let url = URL(fileURLWithPath: path!)
            do { try  audio = AVAudioPlayer(contentsOf: url) }
            catch{ fatalError() }
            audio?.prepareToPlay()
        }
    }

    func stopAudio(){
        queue.async { [self] in
            audio?.stop()
            audio?.currentTime = 0
        }
    }

    func playAudio(volume: Float = 1.0){
        queue.async { [self] in
            audio?.stop()
            audio?.currentTime = 0
            audio?.volume = volume
            audio?.play()
        }
    }

}
