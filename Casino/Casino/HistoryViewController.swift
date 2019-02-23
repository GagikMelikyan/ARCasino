//
//  HistoryViewController.swift
//  Casino
//
//  Created by seattle on 1/24/19.
//  Copyright © 2019 ACA. All rights reserved.
//

import UIKit
import Firebase

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,HistoryTableViewCellDelegate  {


    @IBOutlet weak var tableView: UITableView!
    
    var history: [History] = []
    private var ref: DatabaseReference  = Database.database().reference()
    let userId = UserDefaults.standard.string(forKey: "userId")
    
    
    var dailyHistory: [[DailyHistory]] = [[]]
    var date: String!
    var historyId: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "HistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "HistoryTableViewCell")
          tableView.register(UINib(nibName: "DailyHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "DailyHistoryTableViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        getHistoryFromFirebase()
 //       dailyHistory.removeAll()
    }
    
    @IBAction func goToBack() {
        navigationController?.popViewController(animated: true)
    }
    
    // Mark: - Tableview configuratopn
   func numberOfSections(in tableView: UITableView) -> Int {
        return history.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section >= dailyHistory.count {
            return 0
        }
        return dailyHistory[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (history[indexPath.section].isExpanded) {
            return 44
        }
           return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let date = history[section].date
        let header = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell") as! HistoryTableViewCell
        header.delegate = self
        header.dateLabel.text = date
        header.backgroundColor = .white
        header.section = section
        header.balanceChanging.text = history[section].diffBalance
        if Int(header.balanceChanging.text!)! >= 0 {
            header.balanceChanging.textColor = .green
        } else {
            header.balanceChanging.textColor = .red
        }
        
        if history[section].isExpanded {
                header.arrow.transform = CGAffineTransform(rotationAngle: .pi / 2)
        }
        return header
    }
    
   // Mark: - Tableview cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DailyHistoryTableViewCell", for: indexPath) as! DailyHistoryTableViewCell
        cell.balanceLabel.text = dailyHistory[indexPath.section][indexPath.row].diffBalance
        cell.timeLabel.text =  dailyHistory[indexPath.section][indexPath.row].time

        if Int(cell.balanceLabel.text!)! >= 0 {
            cell.balanceLabel.textColor = .green
        } else {
            cell.balanceLabel.textColor = .red
        }
        
        return cell
    }
    
    func getHistoryFromFirebase() {
        ref.child("userHistory").child(userId!).observeSingleEvent(of: .value, with: {[weak self] (snapshot) in
            let value = snapshot.value as? NSDictionary
            if value != nil {
                let firebaseHistory = value!.allValues as! [[String: String]]
                self!.getHistory(fireHistory: firebaseHistory)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getHistory(fireHistory: [[String: String]]) {
        for i in fireHistory {
            let history = History(i)
            self.history.append(history)
            dailyHistory.append([DailyHistory]())
        }
        self.history = self.history.sorted { $0.date > $1.date }
        tableView.reloadData()
    }
    
    
    func toggleSection(header: HistoryTableViewCell, section: Int, image: UIImageView) {
        
        if !history[section].isExpanded {
            history[section].isExpanded = !history[section].isExpanded
        let Id = userId! + history[section].date
            historyId = ""
        for i in Id.split(separator: ".") {
            historyId += i + "+"
        }
            getHistoryFromFirebase1(section: section)
      
        } else {
            history[section].isExpanded = !history[section].isExpanded
            dailyHistory[section].removeAll()
            tableView.reloadData()
        }
    }
    

    func getHistoryFromFirebase1(section: Int) {
        ref.child("userDailyHistory").child(userId!).child(historyId).observeSingleEvent(of: .value, with: {[weak self] (snapshot) in
            let value = snapshot.value as? NSDictionary
            if value != nil {
                let firebaseHistory = value!.allValues as! [[String: String]]
                self!.getHistory1(fireHistory: firebaseHistory, section: section)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getHistory1(fireHistory: [[String: String]], section: Int) {
        self.dailyHistory[section].removeAll()
        for i in fireHistory {
            let history = DailyHistory(time: i["time"] ?? "", date: i["date"] ?? "", startBalance: i["startBalance"] ?? "", finishBalance: i["finishBalance"] ?? "")
            self.dailyHistory[section].append(history)
        }
        self.dailyHistory[section] = self.dailyHistory[section].sorted { $0.time > $1.time }
        tableView.reloadData()
    }
}
