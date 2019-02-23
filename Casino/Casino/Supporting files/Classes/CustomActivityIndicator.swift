//
//  CustomActivityIndicator.swift
//  Casino
//
//  Created by Admin on 2/6/19.
//  Copyright © 2019 ACA. All rights reserved.
//

import Foundation
import UIKit

class  CustomActivityIndicator: CAShapeLayer {
    
    
    init(frame: CGRect) {
        super.init()
        
        self.configure(frame: frame)
        
        self.fillColor = nil
        self.strokeColor = UIColor.white.cgColor
        self.lineWidth = 2
        
        self.strokeEnd = 0.6
        self.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimation() {
        isHidden = false
        let rotate = CABasicAnimation(keyPath: "transform.rotation")
        rotate.fromValue = 0
        rotate.toValue = Double.pi * 2
        rotate.repeatCount = .infinity
        rotate.isRemovedOnCompletion = false
        rotate.fillMode = .forwards
        rotate.duration = 0.7
        
        add(rotate, forKey: rotate.keyPath)
    }
    
    func stopAnimation() {
        isHidden = true
        removeAllAnimations()
    }
    
    func configure(frame: CGRect) {
        self.frame = CGRect(x: 0, y: 0, width: frame.height, height: frame.height)
        self.path = UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: frame.height / 4, startAngle: CGFloat(-Double.pi / 2) , endAngle: CGFloat(Double.pi * 2), clockwise: true).cgPath
    }
}



