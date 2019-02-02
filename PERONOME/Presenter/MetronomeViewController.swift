//
//  MetronomeViewController.swift
//  PERONOME
//
//  Created by 佐川晴海 on 2019/01/26.
//  Copyright © 2019 佐川　晴海. All rights reserved.
//

import UIKit

class MetronomeViewController: UIViewController {
    @IBOutlet weak var pendulumImage: UIImageView!
    
    @IBOutlet weak var tempoLabel: UILabel!
    
    @IBOutlet weak var addTempoButton: UIButton! {
        didSet {
            addTempoButton.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longPressAdded(_:))))
        }
    }
    @IBOutlet weak var subTempoButton: UIButton!
    
    @IBOutlet weak var startStopButton: UIButton!
    
    var stepValue:Int = 120
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @objc func longPressAdded(_ sender: UILongPressGestureRecognizer) {
        
        if sender.state == .began{
            print("lpngadd")
//            timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true){(_) in
//                self.stepVal = self.stepVal + 1
//                self.tempoLbl.text = String(Int(self.stepVal))
//            }
        }
        if sender.state == .ended{
            //タイマーを破棄する
//            timer?.invalidate()
        }
    }
    @objc func longPressSubed(_ sender: UILongPressGestureRecognizer){
        
    }
    
    @IBAction func addTempo(_ sender: Any) {
        stepValue += 1
        tempoLabel.text = String(stepValue)
    }
    @IBAction func subTempo(_ sender: Any) {
        stepValue -= 1
        tempoLabel.text = String(stepValue)
    }
    @IBAction func startStop(_ sender: Any) {
        
    }
    
    
}
