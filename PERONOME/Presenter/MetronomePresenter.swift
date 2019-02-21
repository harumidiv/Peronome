//
//  MetronomePresenter.swift
//  PERONOME
//
//  Created by 佐川晴海 on 2019/02/02.
//  Copyright © 2019 佐川　晴海. All rights reserved.
//

import Foundation

protocol MetronomePresenter {
    init(output: MetronomePresenterOutput, tempo: Double)
    func addTempo()
    func subTempo()
    func startStopState()
    func playAudio()
    func stopAudio()
    func loadAudio()
}
protocol MetronomePresenterOutput: AnyObject {
    func showLabel(tempo: String)
    func showStartMetronome(speed: Double)
    func showStopMetronome(speed: Double)
}

class MetronomePresenterImpl: MetronomePresenter {
    
    private weak var output: MetronomePresenterOutput!
    private var model: MetronomeModel!
    private var stepValue: Double
    private var move: Bool = false
    
    required init(output: MetronomePresenterOutput, tempo: Double) {
        self.output = output
        self.stepValue = tempo
        model = MetronomeModel()
    }
    func loadAudio(){
        model.loadAudio()
    }
    
    func playAudio(){
        model.playAudio()
    }
    func stopAudio(){
        model.stopAudio()
    }
    
    func addTempo(){
        if stepValue >= 240 {
            return
        }
        stepValue += 1
        output.showLabel(tempo: String(Int(stepValue)))
    }
    
    func subTempo() {
        if stepValue <= 40 {
            return
        }
        stepValue -= 1
        output.showLabel(tempo: String(Int(stepValue)))
    }
    
    func startStopState(){
        if(move){
            move  = !move
            output.showStopMetronome(speed: 60.0/stepValue)
        }else{
            move  = !move
            output.showStartMetronome(speed: 60.0/stepValue)
        }
    }
}
