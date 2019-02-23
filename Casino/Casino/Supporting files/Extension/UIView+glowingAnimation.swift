//
//  UIView+glowingAnimation.swift
//  Casino
//
//  Created by Admin on 1/17/19.
//  Copyright © 2019 ACA. All rights reserved.
//

import Foundation
import UIKit
extension UIView {
    
    //  @IBInspectable var animDuration : CGFloat = 3
    //   @IBInspectable var cornerRadius : CGFloat = 5
    //  @IBInspectable var maxGlowSize : CGFloat = 10
    //   @IBInspectable var minGlowSize : CGFloat = 0
    @IBInspectable
    var cornerRadus: CGFloat {
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = true
        } get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor {
        set {
            layer.shadowColor = newValue.cgColor
        } get {
            return UIColor(cgColor: layer.shadowColor!)
        }
    }
    
    func startGlowingAnimation(maxGlowSize: Int)
    {
        shadowColor = .customGold
        self.layer.shadowOpacity = 1
        self.layer.shadowPath = CGPath(roundedRect: self.bounds, cornerWidth: cornerRadus, cornerHeight: cornerRadus, transform: nil)
        self.layer.shadowOffset = CGSize.zero
        let layerAnimation = CABasicAnimation(keyPath: "shadowRadius")
        layerAnimation.fromValue = maxGlowSize
        layerAnimation.toValue = 3
        layerAnimation.autoreverses = true
        layerAnimation.isAdditive = false
        layerAnimation.duration = CFTimeInterval(0.7)
        layerAnimation.fillMode = CAMediaTimingFillMode.forwards
        layerAnimation.isRemovedOnCompletion = false
        layerAnimation.repeatCount = .infinity
        self.layer.add(layerAnimation, forKey: "glowingAnimation")
    }
    
}

