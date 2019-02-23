//
//  DailyRewardViewController.swift
//  Casino
//
//  Created by Admin on 1/16/19.
//  Copyright © 2019 ACA. All rights reserved.
//

import UIKit

class DailyRewardViewController: UIViewController {
    
    @IBOutlet weak var day1: UIView!
    @IBOutlet weak var day2: UIView!
    @IBOutlet weak var day3: UIView!
    weak var delegate: BlurredEffectDelegate?
    var daysCount: Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if daysCount == 1 {
            day1.backgroundColor = UIColor(hexTorgb: 0xBEA359)
            day2.backgroundColor = UIColor(hexTorgb: 0x21464F)
            day3.backgroundColor = UIColor(hexTorgb: 0x21464F)
            day1.startGlowingAnimation(maxGlowSize: 15)
        } else {
            if daysCount == 2 {
                day1.backgroundColor = UIColor(hexTorgb: 0x21464F)
                day2.backgroundColor = UIColor(hexTorgb: 0xBEA359)
                day3.backgroundColor = UIColor(hexTorgb: 0x21464F)
                day2.startGlowingAnimation(maxGlowSize: 15)
                
            } else {
                day1.backgroundColor = UIColor(hexTorgb: 0x21464F)
                day2.backgroundColor = UIColor(hexTorgb: 0x21464F)
                day3.backgroundColor = UIColor(hexTorgb: 0xBEA359)
                day3.startGlowingAnimation(maxGlowSize: 15)
                
            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first!.view === view {
            self.dismiss(animated: true, completion: nil)
            delegate?.removeBlurredBackgroundView()
        }
    }
}
