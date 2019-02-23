//
//  File.swift
//  Casino
//
//  Created by Garush Batikyan on 1/12/19.
//  Copyright © 2019 ACA. All rights reserved.
//

import UIKit

extension UITextField {
    
    func validateEmail() -> Bool {
        let regex = try? NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}", options: .caseInsensitive)
        
        if ((regex?.firstMatch(in: self.text!, options: .reportCompletion, range: NSMakeRange(0, self.text!.count))) != nil) {
            return true
        }
        return false
    }
    
    func validatePhoneNumber(value: String) -> Bool {
        let PHONE_REGEX = "^((\\+)|(00))[0-9]{6,14}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    
    func validateAge(birthDay: Date) -> Bool {
        let now = Date()
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthDay, to: now)
        let age = ageComponents.year!
        if age >= 18 {
            return true
        }
        return false
    }
    
    func validatePassword() -> Bool {
        if self.text!.count >= 6 {
            return true
        }
        return false
    }
    
//    func changeDesign()  {
//        let color = UIColor.init(displayP3Red: 0.129, green: 0.274, blue: 0.305, alpha: 1).cgColor
//        let border = CALayer()
//        let width = CGFloat(4.0)
//        border.borderColor = UIColor.white.cgColor
//        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: self.frame.size.height)
//
//        border.borderWidth = width
//        self.layer.addSublayer(border)
//        self.layer.masksToBounds = true
//        self.attributedPlaceholder = NSAttributedString(string: "sadasdsdadasdasd",
//                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
//
//    }
}


