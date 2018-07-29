//
//  ViewController.swift
//  PERONOME
//
//  Created by 佐川　晴海 on 2018/07/28.
//  Copyright © 2018年 佐川　晴海. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // 振り子のイメージ
    private var pendulumImgView:UIImageView!
    let pendulumImg:[UIImage] = [
        UIImage(named: "img1")!,
        UIImage(named: "img2")!]
    //ラベル
    var tempoLbl:UILabel!
    //ボタン
    var startStopBtn:UIButton!
    var doMetoronome:Int = 0
    var addTempoBtn:UIButton!
    var subTempoBtn:UIButton!
    var stepVal:Double = 120
    var timer:Timer?
    
    //メイン処理-------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        addItems()
    }
    func addItems(){
        addImage()
        addStartStopBtn()
        addAddTempoBtn()
        addSubTempoBtn()
        addTempoLbl()
    }
    
    //追加UI-----------------------------------------------------------------------------
    //振り子
    func addImage(){
        //振り子の画像を表示
        pendulumImgView = UIImageView(image: pendulumImg[0])
        pendulumImgView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height:                self.view.frame.height)
        
        self.view.addSubview(pendulumImgView)
    }
    //テンポの数値
    func addTempoLbl(){
        tempoLbl = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width/2, height: self.view.frame.height/10))
        tempoLbl.text = String(Int(stepVal))
        tempoLbl.textColor = UIColor(red: 0.1, green: 0.1, blue: 1.0, alpha: 1.0)
        tempoLbl.textAlignment = NSTextAlignment.center
        tempoLbl.font = UIFont.systemFont(ofSize: 72)
        tempoLbl.backgroundColor = .red
        tempoLbl.layer.position = CGPoint(x: self.view.frame.width/4, y: self.view.frame.height/10)
        self.view.addSubview(tempoLbl)
    }
    //ボタン各種
    func addStartStopBtn(){
        startStopBtn = UIButton()
        startStopBtn.frame = CGRect(x: 0, y: 0, width: self.view.frame.width/3, height: self.view.frame.height/10)
        startStopBtn.layer.position = CGPoint(x: self.view.frame.width/4, y: self.view.frame.height - self.view.frame.height/10)
        startStopBtn.backgroundColor = UIColor.red
        startStopBtn.addTarget(self, action: #selector(tapStartStop), for: .touchDown)
        self.view.addSubview(startStopBtn)
    }
    func addAddTempoBtn(){
        addTempoBtn = UIButton()
        addTempoBtn.frame = CGRect(x: 0, y: 0, width: self.view.frame.width/7, height: self.view.frame.width/7)
        addTempoBtn.layer.position = CGPoint(x: self.view.frame.width/3, y: self.view.frame.height - self.view.frame.height/5)
        addTempoBtn.backgroundColor = .blue
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressAdd(gesture:)))
        addTempoBtn.addGestureRecognizer(longPress)
        addTempoBtn.addTarget(self, action:#selector(tapAddTempoBtn(sender:)), for: .touchDown)
        self.view.addSubview(addTempoBtn)
    }
    func addSubTempoBtn(){
        subTempoBtn = UIButton()
        subTempoBtn.frame = CGRect(x: 0, y: 0, width: self.view.frame.width/7, height: self.view.frame.width/7)
        subTempoBtn.layer.position = CGPoint(x: self.view.frame.width/9, y: self.view.frame.height - self.view.frame.height/5)
        subTempoBtn.backgroundColor = .gray
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressSub(gesture:)))
        subTempoBtn.addGestureRecognizer(longPress)
        subTempoBtn.addTarget(self, action: #selector(tapSubTempoBtn(sender:)), for: .touchDown)
        self.view.addSubview(subTempoBtn)
        
    }
    //イベントハンドラ-------------------------------------------------------------------------------
    
    @objc func longPressSub(gesture:UILongPressGestureRecognizer){
        if gesture.state == .began{
            print("longsub")
            timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true){(_) in
                self.stepVal = self.stepVal - 1
                self.tempoLbl.text = String(Int(self.stepVal))
            }
        }
        if gesture.state == .ended{
            //タイマーを破棄する
            timer?.invalidate()
        }
    }
    @objc func longPressAdd(gesture:UILongPressGestureRecognizer){
        
        if gesture.state == .began{
            print("lpngadd")
            timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true){(_) in
                self.stepVal = self.stepVal + 1
                self.tempoLbl.text = String(Int(self.stepVal))
            }
        }
        if gesture.state == .ended{
            //タイマーを破棄する
            timer?.invalidate()
        }
    }
    @objc func tapStartStop(sender:UIButton){
        //アニメーションの間隔の設定
        pendulumImgView.animationImages = pendulumImg
        let speed:Double = 60.0/stepVal
        pendulumImgView.animationDuration = TimeInterval(speed)
        pendulumImgView.animationRepeatCount = 0
        //StartStop処理,ボタンの表示非表示
        doMetoronome += 1
        if(doMetoronome % 2 == 0){
            pendulumImgView.stopAnimating()
            startStopBtn.setTitle("▲", for: UIControlState.normal)
            addTempoBtn.isHidden = false
            subTempoBtn.isHidden = false
        }else{
            pendulumImgView.startAnimating()
            startStopBtn.setTitle("■", for: UIControlState.normal)
            addTempoBtn.isHidden = true
            subTempoBtn.isHidden = true
        }
    }
    @objc func tapAddTempoBtn(sender:UIButton){
        stepVal = stepVal + 1
        tempoLbl.text = String(Int(stepVal))
    }
    @objc func tapSubTempoBtn(sender:UIButton){
        stepVal = stepVal - 1
        tempoLbl.text = String(Int(stepVal))
    }
}

