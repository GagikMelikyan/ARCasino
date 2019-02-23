//
//  UIDatePicker+yearsLimit .swift
//  Casino
//
//  Created by seattle on 1/23/19.
//  Copyright © 2019 ACA. All rights reserved.
//

import UIKit


extension UIDatePicker {
    
    func limitYears() {
        var components = DateComponents()
        components.year = -100
        let minDate = Calendar.current.date(byAdding: components, to: Date())
        
        components.year = -18
        let maxDate = Calendar.current.date(byAdding: components, to: Date())
        
        self.minimumDate = minDate
        self.maximumDate = maxDate
        
    }
}
