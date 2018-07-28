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
    let tongueDownImg = UIImage(named: "img1")
    let toungeUpImg   = UIImage(named: "img2")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pendulumImg = UIImageView(image: toungeUpImg)
        pendulumImg.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(pendulumImg)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}

