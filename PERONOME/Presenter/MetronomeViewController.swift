//
//  MetronomeViewController.swift
//  PERONOME
//
//  Created by 佐川晴海 on 2019/01/26.
//  Copyright © 2019 佐川　晴海. All rights reserved.
//

import UIKit
import AVFoundation

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
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressSubed(_:)))
            subTempoButton.addGestureRecognizer(longPress)
        }
    }
    @IBOutlet weak var startStopButton: UIButton!
    
    var timer:Timer?
    let pendulumImg:[UIImage] = [
        UIImage(named: "img1")!,
        UIImage(named: "img2")!]
    var move: Bool = false
    var audio: AVAudioPlayer?
    
    var presenter: MetronomePresenter?
    
    // MARK: Life-Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = Bundle.main.path(forResource: "metronomeSound", ofType: "mp4")
        let url = URL(fileURLWithPath: path!)
        do { try  audio = AVAudioPlayer(contentsOf: url) }
        catch{ fatalError() }
        audio?.prepareToPlay()
        
        presenter  = MetronomePresenterImpl(output: self, tempo: 120)
    }
    
    // MARK: Event
    
    @objc func longPressAdded(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began{
            timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true){(_) in
                self.presenter?.addTempo()
            }
        }
        if sender.state == .ended{
            timer?.invalidate()
        }
    }
    
    @objc func longPressSubed(_ sender: UILongPressGestureRecognizer){
        if sender.state == .began{
            timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true){(_) in
                self.presenter?.subTempo()
            }
        }
        if sender.state == .ended{
            timer?.invalidate()
        }
    }
    
    @IBAction func addTempo(_ sender: Any) {
        presenter?.addTempo()
    }
    @IBAction func subTempo(_ sender: Any) {
        presenter?.subTempo()
    }
    @IBAction func startStop(_ sender: Any) {
        presenter?.startStopState(move: move)
    }
}

// MARK: Extension MetronomePresenterOutput

extension MetronomeViewController: MetronomePresenterOutput {
    
    func showLabel(tempo: String) {
        tempoLabel.text = tempo
    }
    
    func showStartMetronome(speed: Double) {
        if audio?.isPlaying == true {
            audio?.currentTime = 0
        }
        audio?.play()
        
        pendulumImage.animationImages = pendulumImg
        pendulumImage.animationDuration = TimeInterval(speed)
        pendulumImage.animationRepeatCount = 0
        
        move  = !move
        pendulumImage.startAnimating()
        let img = UIImage(named: "stopBtnImg")
        startStopButton.setBackgroundImage(img, for: .normal)
        changeButtonIsHidden()
    }
    
    func showStopMetronome(speed: Double) {
        audio?.stop()
        
        pendulumImage.animationImages = pendulumImg
        pendulumImage.animationDuration = TimeInterval(speed)
        pendulumImage.animationRepeatCount = 0
        
        move  = !move
        pendulumImage.stopAnimating()
        let img = UIImage(named: "startBtnImg")
        startStopButton.setBackgroundImage(img, for: .normal)
        changeButtonIsHidden()
    }
    
    func changeButtonIsHidden() {
        addTempoButton.isHidden = !addTempoButton.isHidden
        subTempoButton.isHidden = !subTempoButton.isHidden
    }
}
