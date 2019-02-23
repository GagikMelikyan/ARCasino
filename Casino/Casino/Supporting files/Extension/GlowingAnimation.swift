//
//  UIView+glowingAnimation.swift
//  Casino
//
//  Created by Admin on 1/17/19.
//  Copyright © 2019 ACA. All rights reserved.
//

import UIKit

extension UIView {

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
        self.layer.shadowPath = CGPath(rect: self.bounds, transform: nil)
        self.layer.shadowOffset = CGSize.zero
        let layerAnimation = CABasicAnimation(keyPath: "shadowRadius")
        layerAnimation.fromValue = maxGlowSize
        layerAnimation.toValue = 5
        layerAnimation.autoreverses = true
        layerAnimation.isAdditive = false
        layerAnimation.duration = 0.7
        layerAnimation.fillMode = .forwards
        layerAnimation.isRemovedOnCompletion = false
        layerAnimation.repeatCount = .infinity
        self.layer.add(layerAnimation, forKey: "glowingAnimation")
    }
    
}


