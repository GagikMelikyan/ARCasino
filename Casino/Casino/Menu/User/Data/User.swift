//
//  User.swift
//  Casino
//
//  Created by seattle on 1/7/19.
//  Copyright © 2019 ACA. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class User {
    
    private var ref: DatabaseReference  = Database.database().reference()
    var userInfo: Dictionary<String, String>
    
    init(user: [String: String]) {
        self.userInfo = user
    }
    
    func createUser(userData: [String: String], userId: String) -> Bool {
        let dict: NSDictionary = userData as NSDictionary
        self.ref.child("users").child(userId).setValue(dict)
        return true
    }
    
    func changeBalance(userId: String, balance: Int) {
        self.ref.child("users").child(userId).setValue(["balance": "\(balance)"])
    }
    
    func addHistory(history: History) {
        var historyId = ""
        let userId = UserDefaults.standard.string(forKey: "userId")
        let Id = userId! + history.date 
        for i in Id.split(separator: ".") {
            historyId += i + "+"
        }
        
        ref.child("userHistory").child(userId!).child(historyId).observeSingleEvent(of: .value, with: { [weak self] (snapshot)  in
            let value = snapshot.value as? NSDictionary
            if value != nil {
                var currentHistory = history
                currentHistory.startBalance = (value!["StartBalance"] as? String)!
            }
            self!.ref.child("userHistory").child(userId!).child(historyId).setValue(history.dictionary)
        }) { (error) in
            print(error.localizedDescription)
        }
    
    }
    
    func addDailyHistory(dailyHistory: DailyHistory) {
        var historyId = ""
        let userId = UserDefaults.standard.string(forKey: "userId")
        let Id = userId! + dailyHistory.date
        for i in Id.split(separator: ".") {
            historyId += i + "+"
        }
        var gameId = historyId
        for i in dailyHistory.time.split(separator: ".") {
            gameId += i + "+"
        }
        self.ref.child("userDailyHistory").child(userId!).child(historyId).child(gameId).setValue(dailyHistory.dictionary)
    }
    
    
}
