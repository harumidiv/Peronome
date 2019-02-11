//
//  MetronomePresenter.swift
//  PERONOME
//
//  Created by 佐川晴海 on 2019/02/02.
//  Copyright © 2019 佐川　晴海. All rights reserved.
//

import Foundation

protocol MetronomePresenter {
    init(output: MetronomePresenterOutput)
    func addTempo(tempo: Int)
    func subTempo(tempo: Int)
    func startStopState(move: Bool)

}
protocol MetronomePresenterOutput: AnyObject {
    func showPendulumImage()
    func showLabel(tempo: String)
    func startMetronome()
    func stopMetronome()
}

class MetronomePresenterImpl: MetronomePresenter {
    
    private weak var output: MetronomePresenterOutput!
    
    required init(output: MetronomePresenterOutput) {
        self.output = output
    }
    
    func addTempo(tempo: Int){
        output.showLabel(tempo: String(tempo + 1))
    }
    
    func subTempo(tempo: Int) {
       output.showLabel(tempo: String(tempo - 1))
    }
    func startStopState(move: Bool){
        if(move){
            output.stopMetronome()
        }else{
            output.startMetronome()
        }
    }
}