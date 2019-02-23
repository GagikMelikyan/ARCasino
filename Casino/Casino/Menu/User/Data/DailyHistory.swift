//
//  DailyHistory.swift
//  Casino
//
//  Created by seattle on 1/25/19.
//  Copyright © 2019 ACA. All rights reserved.
//

import Foundation


struct DailyHistory {
    var time: String
    var date: String
    var startBalance: String
    var finishBalance: String
    
    var diffBalance: String {
        return String(Int(finishBalance)! - Int(startBalance)!)
    }
    
    var dictionary: [String: String] {
        return ["startBalance": startBalance,
                "finishBalance": finishBalance,
                "date": date,
                "time": time]
    }
    
    init(time: String, date: String, startBalance: String, finishBalance: String) {
        self.startBalance = startBalance
        self.finishBalance = finishBalance
        self.date = date
        self.time = time
    }
    
}
