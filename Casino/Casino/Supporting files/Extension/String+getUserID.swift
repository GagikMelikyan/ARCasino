//
//  String+getUserID.swift
//  Casino
//
//  Created by seattle on 1/16/19.
//  Copyright © 2019 ACA. All rights reserved.
//

import Foundation

extension String {
    
    func getUserId() -> String {
        var userId = ""
        for i in self.split(separator: ".") {
            userId += i + "+"
        }
        return userId
    }
    
}
