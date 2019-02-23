//
//  DailyHistoryVC.swift
//  Casino
//
//  Created by seattle on 1/25/19.
//  Copyright © 2019 ACA. All rights reserved.
//

import UIKit
import Firebase

class DailyHistoryVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
  

    var dailyHistory: [DailyHistory] = []
    private var ref: DatabaseReference  = Database.database().reference()
    let userId = UserDefaults.standard.string(forKey: "userId")
    var date: String!
    var historyId: String = ""
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "DailyHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "DailyHistoryTableViewCell")
        
        let Id = userId! + date
        for i in Id.split(separator: ".") {
            historyId += i + "+"
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getHistoryFromFirebase()
    }

    @IBAction func goToBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DailyHistoryTableViewCell", for: indexPath) as! DailyHistoryTableViewCell

     //   let date = dailyHistory[indexPath.row].date
        
        cell.balanceLabel.text = dailyHistory[indexPath.row].diffBalance
        cell.timeLabel.text =  dailyHistory[indexPath.row].time
        if Int(cell.balanceLabel.text!)! >= 0 {
            cell.balanceLabel.textColor = .green
        } else {
            cell.balanceLabel.textColor = .red
        }
    
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return date
    }
    
    func getHistoryFromFirebase() {
        
        ref.child("userDailyHistory").child(userId!).child(historyId).observeSingleEvent(of: .value, with: {[weak self] (snapshot) in
            let value = snapshot.value as? NSDictionary
            if value != nil {
//                print(value)
                let firebaseHistory = value!.allValues as! [[String: String]]
                self!.getHistory(fireHistory: firebaseHistory)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getHistory(fireHistory: [[String: String]]) {
        for i in fireHistory {
            let history = DailyHistory(time: i["time"] ?? "", date: i["date"] ?? "", startBalance: i["startBalance"] ?? "", finishBalance: i["finishBalance"] ?? "")
            self.dailyHistory.append(history)
        }
        tableView.reloadData()
    }

}
