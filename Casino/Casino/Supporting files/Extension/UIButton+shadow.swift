//
//  UIButton+shadow.swift
//  Casino
//
//  Created by Admin on 1/21/19.
//  Copyright © 2019 ACA. All rights reserved.
//

import UIKit

extension UIButton {
    
    @IBInspectable
    var shadow: Bool {
        set {
            layer.masksToBounds = false
            layer.shadowOffset = CGSize(width: 0, height: 4)
            layer.shadowRadius = 5
            layer.shadowOpacity = 0.5
        } get {
            return true
        }
    }
}
