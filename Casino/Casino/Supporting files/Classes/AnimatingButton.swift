//
//  AnimatingButton.swift
//  Casino
//
//  Created by Admin on 2/5/19.
//  Copyright © 2019 ACA. All rights reserved.
//

import Foundation
import UIKit

class AnimatingButton: UIButton  {
    
    
   private var oldTitle: String!
   private lazy var spiner: CustomActivityIndicator = {
        let spiner = CustomActivityIndicator(frame: self.frame)
        self.layer.addSublayer(spiner)
        return spiner
    }()
    
    func startAnimation() {
        isUserInteractionEnabled = false
        self.translatesAutoresizingMaskIntoConstraints = false
        oldTitle = titleLabel?.text
        
        setTitle("", for: .normal)
        UIView.animate(withDuration: 0.1, animations: {

            self.clipsToBounds = true
            self.layer.cornerRadius = self.frame.size.height / 2
        }) { (true) in
            self.shrink()
            self.spiner.startAnimation()
        }
    }
    
    private func shrink() {
        let shrinkAnim = CABasicAnimation(keyPath: "bounds.size.width")
        shrinkAnim.fromValue = frame.width
        shrinkAnim.toValue = frame.height
        shrinkAnim.duration = 0.1
        shrinkAnim.timingFunction = CAMediaTimingFunction(name: .linear)
        shrinkAnim.fillMode = .forwards
        shrinkAnim.isRemovedOnCompletion = false
        
        layer.add(shrinkAnim, forKey: shrinkAnim.keyPath)
    }
    
    private func expand(completion: (()->Void)? = nil) {
        let expandinAmination = CABasicAnimation(keyPath: "transform.scale")
        expandinAmination.fromValue = 1.0
        expandinAmination.toValue = (UIScreen.main.bounds.size.height/self.frame.size.height)*2
        expandinAmination.fillMode = .forwards
        expandinAmination.isRemovedOnCompletion = false
        expandinAmination.duration = 0.3
        expandinAmination.timingFunction = CAMediaTimingFunction(name: .linear)
        
        CATransaction.setCompletionBlock {
            completion?()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.setOriginalState()
                self.layer.removeAllAnimations()
            }
        }
        
        layer.add(expandinAmination, forKey: expandinAmination.keyPath)
    }
    
    func setOriginalState() {
        self.animateToOriginalWidth()
        self.spiner.stopAnimation()
        self.setTitle(self.oldTitle, for: .normal)
        self.isUserInteractionEnabled = true
        self.layer.cornerRadius = 0
    }
    
    
    func animateToOriginalWidth(completion: (()->Void)? = nil) {
        let shrinkAnim = CABasicAnimation(keyPath: "bounds.size.width")
        shrinkAnim.fromValue = frame.height
        shrinkAnim.toValue = frame.width
        shrinkAnim.duration = 0.1
        shrinkAnim.timingFunction = CAMediaTimingFunction(name: .linear)
        shrinkAnim.fillMode = .forwards
        shrinkAnim.isRemovedOnCompletion = false
        
        layer.add(shrinkAnim, forKey: shrinkAnim.keyPath)
    }
    
    func stopAnimation(completion: (()->Void)? = nil) {
        spiner.stopAnimation()
        self.expand(completion: completion)
    }
}
