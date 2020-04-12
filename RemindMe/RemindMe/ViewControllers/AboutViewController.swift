//
//  AboutViewController.swift
//  RemindMe
//
//  Created by Quynh Dinh on 2020-04-12.
//  Copyright © 2020 BBQS. All rights reserved.
//

import UIKit
import AVFoundation

class AboutViewController: UIViewController {
    var fadeLayer : CALayer?
    var soundPlayer : AVAudioPlayer?

    override func viewWillAppear(_ animated: Bool) {
        // Set up sound player
        let sound = Bundle.main.path(forResource: "pad_confirm", ofType: "wav")
        
        let url = URL(fileURLWithPath: sound!)
        
        soundPlayer = try! AVAudioPlayer.init(contentsOf:url)
        soundPlayer?.currentTime = 0
        soundPlayer?.volume = 0.5
        soundPlayer?.numberOfLoops = 1
        soundPlayer?.play()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up layer for animation
        let fadeImage = UIImage(named: "remindme_noname_logo.png")
        fadeLayer = CALayer()
        fadeLayer?.contents = fadeImage?.cgImage
        fadeLayer?.bounds = CGRect(x:0, y:0, width:250, height:250)
        fadeLayer?.position = CGPoint(x:210, y:230)
        
        view.layer.addSublayer(fadeLayer!)
        
        // Make the image fade out as changing opacity
        let fadeAnimation = CABasicAnimation(keyPath: "opacity")
        fadeAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        fadeAnimation.fromValue = 0.0
        fadeAnimation.toValue = 1.0
        fadeAnimation.isRemovedOnCompletion = false
        
        // The animation will not start to fade out til the first second
        fadeAnimation.duration = 3.0
        fadeAnimation.beginTime = 1.0 // set the begin fade time at the first second
        fadeAnimation.isAdditive = false
        fadeAnimation.fillMode = .both
        fadeAnimation.repeatCount = .infinity
        fadeAnimation.autoreverses = true // after fade out, fade in back
        fadeLayer?.add(fadeAnimation, forKey: "fadeout")
    }
}
