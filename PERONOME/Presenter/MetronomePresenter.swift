//
//  MetronomePresenter.swift
//  PERONOME
//
//  Created by 佐川晴海 on 2019/02/02.
//  Copyright © 2019 佐川　晴海. All rights reserved.
//

import Foundation

protocol MetronomePresenter {
    init(output: MetronomePresenterOutput, tempo: Int)
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
    private var model: MetronomeModelInput!
    private var move: Bool = false
    
    required init(output: MetronomePresenterOutput, tempo: Int) {
        self.output = output
        model = MetronomeModel(tempo: tempo)
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
        output.showLabel(tempo: String(model.addTempo()))
    }
    
    func subTempo() {
        output.showLabel(tempo: String(model.subTempo()))
    }
    
    func startStopState(){
        if(move){
            move  = !move
            output.showStopMetronome(speed: 60.0/model.speed)
        }else{
            move  = !move
            output.showStartMetronome(speed: 60.0/model.speed)
        }
    }
}
