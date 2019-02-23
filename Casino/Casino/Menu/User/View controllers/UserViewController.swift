//
//  UaserViewController.swift
//  Casino
//
//  Created by seattle on 12/27/18.
//  Copyright © 2018 ACA. All rights reserved.
//

import UIKit
import Firebase

class UserViewController: UIViewController {
    
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    
    private var ref: DatabaseReference  = Database.database().reference()
    let userId = UserDefaults.standard.string(forKey: "userId")
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let firstName = UIApplication.appDelegate.user.userInfo["firstName"] {
            fullNameLabel.text = firstName
            if let lastName = UIApplication.appDelegate.user.userInfo["lastName"] {
                fullNameLabel.text = "\(firstName) \(lastName)"
            }
        }
        if let balance = UIApplication.appDelegate.user.userInfo["balance"] {
            balanceLabel.text = balance
        }
        if let email = UIApplication.appDelegate.user.userInfo["email"] {
            emailLabel.text = email
        }
    }
    
    @IBAction func goToBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func goToHistory() {
        let storyboardPass = UIStoryboard(name: "History", bundle: nil)
        let vc = storyboardPass.instantiateViewController(withIdentifier: "HistoryViewController") as! HistoryViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func goToEdit() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "EditionViewController") as! EditionViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func logOut(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        navigationController?.setViewControllers([vc.self], animated: false)
        navigationController?.popViewController(animated: true)
        UserDefaults.standard.removeObject(forKey: "userId")
        if UserDefaults.standard.bool(forKey: "isMusicOn") {
            AudioPlayer.sharedInstance.mainMusicStop()
        }
    }
}
