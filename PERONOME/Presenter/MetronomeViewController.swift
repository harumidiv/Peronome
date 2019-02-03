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
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressAdded(_:)))
            addTempoButton.addGestureRecognizer(longPress)
        }
    }
    @IBOutlet weak var subTempoButton: UIButton! {
        didSet {
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressAdded(_:)))
            subTempoButton.addGestureRecognizer(longPress)
        }
    }
    @IBOutlet weak var startStopButton: UIButton!
    var timer:Timer?
    var stepValue:Double = 120
    let pendulumImg:[UIImage] = [
        UIImage(named: "img1")!,
        UIImage(named: "img2")!]
    var move: Bool = false
    
    //let presenter = MetronomePresenter(output: self as! MetronomePresenterOutput)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc func longPressAdded(_ sender: UILongPressGestureRecognizer) {
        print("called")
        if sender.state == .began{
            timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true){(_) in
                self.stepValue = self.stepValue + 1
                self.tempoLabel.text = String(Int(self.stepValue))
            }
        }
        if sender.state == .ended{
            //タイマーを破棄する
            timer?.invalidate()
        }
    }
    @objc func longPressSubed(_ sender: UILongPressGestureRecognizer){
        
    }
    
    @IBAction func addTempo(_ sender: Any) {
        stepValue += 1
        tempoLabel.text = String(Int(stepValue))

    }
    @IBAction func subTempo(_ sender: Any) {
        stepValue -= 1
        tempoLabel.text = String(Int(stepValue))
    }
    @IBAction func startStop(_ sender: Any) {
        //アニメーションの間隔の設定
        pendulumImage.animationImages = pendulumImg
        let speed:Double = 60.0/stepValue
        pendulumImage.animationDuration = TimeInterval(speed)
        pendulumImage.animationRepeatCount = 0
        //StartStop処理,ボタンの表示非表示
        move  = !move
        if(move){
            pendulumImage.stopAnimating()
            let img = UIImage(named: "startBtnImg.png")
            startStopButton.setBackgroundImage(img, for: .normal)
            addTempoButton.isHidden = false
            subTempoButton.isHidden = false
        }else{
            pendulumImage.startAnimating()
            let img = UIImage(named: "stopImg.png")
            startStopButton.setBackgroundImage(img, for: .normal)
            addTempoButton.isHidden = true
            subTempoButton.isHidden = true
        }
    }
}

extension MetronomeViewController: MetronomePresenterOutput {
    func showPendulumImage() {
        
    }
    
    func showLabel(tempo: String) {
        tempoLabel.text = tempo
    }
}
