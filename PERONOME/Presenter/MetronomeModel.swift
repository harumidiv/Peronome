//
//  MetronomeModel.swift
//  PERONOME
//
//  Created by 佐川晴海 on 2019/02/22.
//  Copyright © 2019 佐川　晴海. All rights reserved.
//

import Foundation
import AVFoundation

protocol MetronomeModelInput{
    func loadAudio()
    func stopAudio()
    func playAudio()
    func addTempo() -> Int
    func subTempo() -> Int
    var speed: Double {get}
}

class MetronomeModel: MetronomeModelInput{
    private var audio: AVAudioPlayer?
    private var stepValue: Int
    var speed:Double {
        return Double(stepValue)
    }
    
    
    init(tempo: Int) {
        stepValue = tempo
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
        if stepValue >= 240 {
            return stepValue
        }
        stepValue += 1
        return stepValue
    }
    func subTempo() -> Int{
        if stepValue <= 40 {
            return stepValue
        }
        stepValue -= 1
        return stepValue
    }
}
