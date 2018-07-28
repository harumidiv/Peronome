//
//  ViewController.swift
//  PERONOME
//
//  Created by 佐川　晴海 on 2018/07/28.
//  Copyright © 2018年 佐川　晴海. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private var pendulumImg:UIImageView!
    let toungueDownImg = UIImage(named: "img1")
    let toungeUpImg   = UIImage(named: "img2")
    
    var startStopBtn:UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addImage()

        addButton()
        
//        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.moveMetronome), userInfo: nil, repeats: true)
    }
    
//    @objc moveMetronome(){
//        pendulumingImg.image = toungeDownimg
//    }

    
    func addImage(){
        //振り子の画像を表示
        pendulumImg = UIImageView(image: toungeUpImg)
        pendulumImg.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(pendulumImg)
    }
    func addButton(){
        //スタートストップボタン
        startStopBtn = UIButton()
        startStopBtn.frame = CGRect(x: 0, y: 0, width: self.view.frame.width/3, height: self.view.frame.height/10)
        startStopBtn.layer.position = CGPoint(x: self.view.frame.width/4, y: self.view.frame.height - self.view.frame.height/10)
        startStopBtn.backgroundColor = UIColor.red
        startStopBtn.addTarget(self, action: #selector(tapStartStop), for: .touchDown)
        self.view.addSubview(startStopBtn)
    }
    
    @objc func tapStartStop(sender:UIButton){
        if pendulumImg.image == toungeUpImg{
            pendulumImg.image = toungueDownImg
        } else {
            pendulumImg.image = toungeUpImg
        }
    }
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}

