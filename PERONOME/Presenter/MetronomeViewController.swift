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
    @IBOutlet weak var tempoLabel: UILabel! {
        didSet {
            tempoLabel.text = "120"
        }
    }
    @IBOutlet weak var addTempoButton: UIButton! {
        didSet {
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressAdded(_:)))
            addTempoButton.addGestureRecognizer(longPress)
        }
    }
    @IBOutlet weak var subTempoButton: UIButton! {
        didSet {
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressSubed(_:)))
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
    var presenter: MetronomePresenter?
    
    // MARK: Life-Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter  = MetronomePresenterImpl(output: self)
    }
    
    // MARK: Event
    
    @objc func longPressAdded(_ sender: UILongPressGestureRecognizer) {
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
        if sender.state == .began{
            timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true){(_) in
                self.stepValue = self.stepValue - 1
                self.tempoLabel.text = String(Int(self.stepValue))
            }
        }
        if sender.state == .ended{
            //タイマーを破棄する
            timer?.invalidate()
        }
    }
    
    @IBAction func addTempo(_ sender: Any) {
        presenter?.addTempo(tempo: Int(stepValue))
    }
    @IBAction func subTempo(_ sender: Any) {
        presenter?.subTempo(tempo: Int(stepValue))
    }
    @IBAction func startStop(_ sender: Any) {
        //アニメーションの間隔の設定
        pendulumImage.animationImages = pendulumImg
        let speed:Double = 60.0/stepValue
        pendulumImage.animationDuration = TimeInterval(speed)
        pendulumImage.animationRepeatCount = 0

        presenter?.startStopState(move: move)
    }
}

// MARK: Extension MetronomePresenterOutput

extension MetronomeViewController: MetronomePresenterOutput {
    func startMetronome() {
        move  = !move
        pendulumImage.startAnimating()
        let img = UIImage(named: "stopImg.png")
        startStopButton.setBackgroundImage(img, for: .normal)
        addTempoButton.isHidden = true
        subTempoButton.isHidden = true
    }
    
    func stopMetronome() {
        move  = !move
        pendulumImage.stopAnimating()
        let img = UIImage(named: "startBtnImg.png")
        startStopButton.setBackgroundImage(img, for: .normal)
        addTempoButton.isHidden = false
        subTempoButton.isHidden = false
    }
    
    func showPendulumImage() {
        
    }
    
    func showLabel(tempo: String) {
        tempoLabel.text = tempo
    }
}
