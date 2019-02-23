//
//  ShakingAnimation.swift
//  Casino
//
//  Created by Admin on 2/6/19.
//  Copyright © 2019 ACA. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.08
        animation.fromValue =  CGPoint(x: center.x - 10, y: center.y)
        animation.toValue = CGPoint(x: center.x + 10, y: center.y)
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.repeatCount = 2
        animation.autoreverses = true
        animation.isRemovedOnCompletion = false
        
        
        layer.add(animation, forKey: animation.keyPath)
    }
}
