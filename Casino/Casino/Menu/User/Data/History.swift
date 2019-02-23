//
//  History.swift
//  Casino
//
//  Created by seattle on 1/21/19.
//  Copyright © 2019 ACA. All rights reserved.
//

import Foundation


struct History {
//    var startTime: String
//    var finishTime: String
    var date: String
    var startBalance: String
    var finishBalance: String
    var isExpanded: Bool

    var diffBalance: String {
        return String(Int(finishBalance)! - Int(startBalance)!) 
    }
    
    var dictionary: [String: String] {
        return ["StartBalance": startBalance,
                "FinishBalance": finishBalance,
                "Date": date,
        ]
    }
    
    init(_ historyDictionary: [String: String]) {
        self.startBalance = historyDictionary["StartBalance"] ?? ""
        self.finishBalance = historyDictionary["FinishBalance"] ?? ""
        self.date = historyDictionary["Date"] ?? ""
        isExpanded = false

    }
}
