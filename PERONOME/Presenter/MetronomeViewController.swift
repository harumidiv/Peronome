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
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressSubed(_:)))
            subTempoButton.addGestureRecognizer(longPress)
        }
    }
    @IBOutlet weak var startStopButton: UIButton!
    
    var timer:Timer?
    let pendulumImg:[UIImage] = [
        UIImage(named: "img2")!,
        UIImage(named: "img1")!]
    
    var presenter: MetronomePresenter?
    
    // MARK: Life-Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter  = MetronomePresenterImpl(output: self, tempo: 120)
        presenter?.loadAudio()
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
        presenter?.startStopState()
    }
}

// MARK: Extension MetronomePresenterOutput

extension MetronomeViewController: MetronomePresenterOutput {
    
    func showLabel(tempo: String) {
        tempoLabel.text = tempo
    }
    
    func showStartMetronome(speed: Double) {
        
        presenter?.playAudio()
        timer = Timer.scheduledTimer(withTimeInterval: speed, repeats: true){(_) in
            self.presenter?.stopAudio()
            self.presenter?.playAudio()
        }
        
        pendulumImage.animationImages = pendulumImg
        pendulumImage.animationDuration = TimeInterval(speed)
        pendulumImage.animationRepeatCount = 0
        pendulumImage.startAnimating()
        changeButtonImageAndIsHidden(image: UIImage(named: "stopBtnImg")!)
    }
    
    func showStopMetronome(speed: Double) {
        presenter?.stopAudio()
        timer?.invalidate()
        pendulumImage.stopAnimating()
        changeButtonImageAndIsHidden(image: UIImage(named: "startBtnImg")!)
    }
    
    func changeButtonImageAndIsHidden(image: UIImage) {
        startStopButton.setBackgroundImage(image, for: .normal)
        addTempoButton.isHidden = !addTempoButton.isHidden
        subTempoButton.isHidden = !subTempoButton.isHidden
    }
}
