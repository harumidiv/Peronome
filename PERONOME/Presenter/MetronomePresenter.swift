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
    func startStopState(move: Bool)

}
protocol MetronomePresenterOutput: AnyObject {
    func showLabel(tempo: String)
    func showStartMetronome(speed: Double)
    func showStopMetronome(speed: Double)
}

class MetronomePresenterImpl: MetronomePresenter {
    
    
    private weak var output: MetronomePresenterOutput!
    private var stepValue: Double
    
    required init(output: MetronomePresenterOutput, tempo: Double) {
        self.output = output
        self.stepValue = tempo
    }
    
    func addTempo(){
        stepValue += 1
        output.showLabel(tempo: String(Int(stepValue)))
    }
    
    func subTempo() {
        stepValue -= 1
        output.showLabel(tempo: String(Int(stepValue)))
    }
    
    func startStopState(move: Bool){
        if(move){
            output.showStopMetronome(speed: 60.0/stepValue)
        }else{
            output.showStartMetronome(speed: 60.0/stepValue)
        }
    }
}
