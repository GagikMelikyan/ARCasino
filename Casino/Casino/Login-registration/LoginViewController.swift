//
//  LoginViewController.swift
//  Casino
//
//  Created by seattle on 12/25/18.
//  Copyright © 2018 ACA. All rights reserved.
//

import UIKit
import FirebaseDatabase

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var logInButton: AnimatingButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var createAccountLabel: UIButton!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        emailField.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createAccountLabel.isHidden = false
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        logInButton.setOriginalState()
        logInButton.layer.removeAllAnimations()
    }
    
    @IBAction func logIn() {
        if emailField.validateEmail() && passField.validatePassword() {
            self.logInButton.startAnimation()
            let userId = emailField.text?.getUserId()
            ref.child("users").child(userId!).observeSingleEvent(of: .value, with: { [weak self] (snapshot)  in
                let value = snapshot.value as? NSDictionary
                if value != nil {
                    let email = value!["email"] as? String
                    let pass = value!["pass"] as? String
                    if email == self!.emailField.text && pass == self!.passField.text {
                        UIApplication.appDelegate.user = User(user: value as! [String : String])
                        UserDefaults.standard.set(userId, forKey: "userId")
                        UserDefaults.standard.set(value, forKey: "user")
                        self!.createAccountLabel.isHidden = true
                        self!.dismissKeyboard()
                        //UserDefaults.standard.set(UIApplication.appDelegate.user, forKey: "user")
                        self!.logInButton.stopAnimation(completion: {
                            if UserDefaults.standard.bool(forKey: "isMusicOn") {
                                AudioPlayer.sharedInstance.mainMusicPlay()
                            }
                            let vc = self!.storyboard?.instantiateViewController(withIdentifier: "ARViewController") as! GameVIewController
                            self!.navigationController?.pushViewController(vc, animated: false)
                            
                        })
                    } else {
                        self!.errorLabel.text = "Something Wrong"
                        self!.errorLabel.textColor = .yellow
                        self!.logInButton.setOriginalState()
                        return
                    }
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func goToRegistration() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "RegViewController")
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func changeRegFormUI(textField: UITextField, label: UILabel) {
        textField.shake()
        label.textColor = .yellow
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.yellow.cgColor
    }

    func defaultRegFormUI(textField: UITextField, label: UILabel) {
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightText.cgColor
    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if emailField.text == "" {
            emailField.becomeFirstResponder()
        } else if passField.text == "" {
            passField.becomeFirstResponder()
        } else {
            logIn()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = CGFloat(5)
        textField.layer.borderColor = UIColor.lightText.cgColor
        errorLabel.text = ""
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case emailField:
            if  textField.validateEmail() {
                errorLabel.text = ""
            } else {
                changeRegFormUI(textField: emailField, label: errorLabel)
                errorLabel.text = "Wrong Email"
            }
        case passField:
            if textField.validatePassword() {
                errorLabel.text = ""
            } else {
                errorLabel.text = "Wrong Password"
                changeRegFormUI(textField: passField, label: errorLabel)
            }
        default:
            return
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.5) {
                self.bottomConstraint.constant = keyboardSize.size.height + 25
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.5) {
            self.bottomConstraint.constant = 70
            self.view.layoutIfNeeded()
        }
    }
}
