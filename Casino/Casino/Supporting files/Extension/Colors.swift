//
//  UIColor+hex.swift
//  Casino
//
//  Created by Admin on 1/17/19.
//  Copyright © 2019 ACA. All rights reserved.
//

import Foundation
import  UIKit

extension UIColor{
    
    static let customBlue = UIColor(hexTorgb: 0x136AA8)
    static let customGreen = UIColor(hexTorgb: 0x338E1C)
    static let customGold = UIColor(hexTorgb: 0xFFD700)
    
    
    convenience init(hexTorgb: UInt) {
        self.init(red: CGFloat((hexTorgb & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((hexTorgb & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(hexTorgb & 0x0000FF) / 255.0, alpha: 1)
    }
}
