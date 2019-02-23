//
//  PasswordEditViewController.swift
//  Casino
//
//  Created by seattle on 1/19/19.
//  Copyright © 2019 ACA. All rights reserved.
//

import UIKit
import Firebase

class PasswordEditViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var oldPassField: UITextField!
    @IBOutlet weak var newPassField: UITextField!
    @IBOutlet weak var reNewPassField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    @IBAction func goToBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func changePass() {
        if oldPassField.validatePassword() && newPassField.validatePassword() && reNewPassField.validatePassword() && (newPassField.text == reNewPassField.text) {
            if UIApplication.appDelegate.user.userInfo["pass"] == oldPassField.text {
                UIApplication.appDelegate.user.userInfo["pass"] = newPassField.text
                UserDefaults.standard.set( UIApplication.appDelegate.user.userInfo, forKey: "user")
                self.ref.child("users/\(UserDefaults.standard.string(forKey: "userId")!)/pass").setValue(newPassField.text)
                navigationController?.popViewController(animated: true)
            }
        } else {
            errorLabel.text = "Something Wrong"
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if oldPassField.text == "" {
            oldPassField.becomeFirstResponder()
        } else if newPassField.text == "" {
            newPassField.becomeFirstResponder()
        }  else if reNewPassField.text == "" {
            reNewPassField.becomeFirstResponder()
        } else {
            changePass()
        }
        return true
    }
    
    func changeRegFormUI(textField: UITextField) {
        textField.shake()
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.yellow.cgColor
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightText.cgColor
        errorLabel.text = ""
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case oldPassField:
            if  oldPassField.validatePassword() {
                if UIApplication.appDelegate.user.userInfo["pass"] != oldPassField.text {
                    changeRegFormUI(textField: oldPassField)
                    errorLabel.text = "Wrong Password"
                }
            } else {
                changeRegFormUI(textField: oldPassField)
                errorLabel.text = "Short Password"
            }
        case newPassField:
            if !newPassField.validatePassword() {
                errorLabel.text = "Short Password"
                changeRegFormUI(textField: newPassField)
            }
        case reNewPassField:
            if !reNewPassField.validatePassword() || reNewPassField.text != newPassField.text {
                errorLabel.text = "Different New Passwords"
                changeRegFormUI(textField: reNewPassField)
            }
            
        default:
            return
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.5) {
                self.bottomConstraint.constant = keyboardSize.size.height
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.5) {
            self.view.endEditing(true)
            self.bottomConstraint.constant = 70
            self.view.layoutIfNeeded()
        }
    }
}
