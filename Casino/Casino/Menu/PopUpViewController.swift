//
//  PopUpViewController.swift
//  Casino
//
//  Created by Admin on 1/10/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

protocol BlurredEffectDelegate: class {
    func removeBlurredBackgroundView()
}

class PopUpViewController: UIViewController {
    
    weak var delegate: BlurredEffectDelegate?
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var soundSwitch: UISwitch!
    @IBOutlet weak var musicSwitch: UISwitch!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        musicSwitch.isOn = UserDefaults.standard.bool(forKey: "isMusicOn")
        soundSwitch.isOn = UserDefaults.standard.bool(forKey: "isSoundOn")
        popUpView.layer.cornerRadius = 10
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first!.view === view {
            self.dismiss(animated: true, completion: nil)
            delegate?.removeBlurredBackgroundView()
        }
    }
    
    @IBAction func onoffSound(_ sender: UISwitch) {
        UserDefaults.standard.set(!UserDefaults.standard.bool(forKey: "isSoundOn"), forKey: "isSoundOn")
    }
    
    @IBAction func onoffMusic(_ sender: Any) {
        switch UserDefaults.standard.bool(forKey: "isMusicOn") {
        case true:
            AudioPlayer.sharedInstance.mainMusicStop()
        case false:
            AudioPlayer.sharedInstance.mainMusicPlay()
        }
        UserDefaults.standard.set(!UserDefaults.standard.bool(forKey: "isMusicOn"), forKey: "isMusicOn")
    }
    
}
