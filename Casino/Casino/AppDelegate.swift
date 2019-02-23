//
//  AppDelegate.swift
//  Casino
//
//  Created by seattle on 12/22/18.
//  Copyright © 2018 ACA. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation
import FirebaseDatabase
 
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var ref: DatabaseReference!
    var window: UIWindow?
    var audioPlayer: AVAudioPlayer!
    var user: User!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        //  Stay loged in if needed
        let mainSB = UIStoryboard(name: "Main", bundle: nil)
        if UserDefaults.standard.string(forKey: "userId") != nil {
            if UserDefaults.standard.dictionary(forKey: "user") != nil {
                user = User(user: UserDefaults.standard.dictionary(forKey: "user") as! [String: String])
            }
            
            let gamesVC = mainSB.instantiateViewController(withIdentifier: "ARViewController") as! GameVIewController
            window?.rootViewController = UINavigationController(rootViewController: gamesVC)
            if UserDefaults.standard.bool(forKey: "isMusicOn") {
                AudioPlayer.sharedInstance.mainMusicPlay()
            }
        } else {
            let loginVC = mainSB.instantiateViewController(withIdentifier: "LoginViewController")
            window?.rootViewController = UINavigationController(rootViewController: loginVC)
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        saveHistoryFinishBalance()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        UserDefaults.standard.set(user.userInfo, forKey: "user")
        
    }
    
    func saveHistoryFinishBalance() {
        ref = Database.database().reference()
        if let userId = UserDefaults.standard.string(forKey: "userId") {
            ref.child("users").child(userId).updateChildValues(["balance": user.userInfo["balance"]!])
        }
    }
    
}


extension UIApplication {
    static var appDelegate: AppDelegate {
        return shared.delegate as! AppDelegate
    }
}
