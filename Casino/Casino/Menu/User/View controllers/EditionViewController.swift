//
//  EditionViewController.swift
//  Casino
//
//  Created by Admin on 1/12/19.
//  Copyright © 2019 ACA. All rights reserved.
//

import UIKit
import Firebase

class EditionViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var birthDayField: UITextField!
    @IBOutlet weak var birthDayLabel: UILabel!
    @IBOutlet weak var genderField: UITextField!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var saveButton: UIButton!
    var ref: DatabaseReference!
    
    
    
    private var birthDay: Date!
    private var datePicker = UIDatePicker()
    private var genderData = ["Male", "Female", "Other"]
    private var genderPicker = UIPickerView()
    private var data = UIApplication.appDelegate.user.userInfo
    private var validData = [String: Bool]()
    private var lastSelectedTextField: UITextField?
    private var activeTextField: UITextField?
    private var isa = true

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        genderPicker.delegate = self
        genderPicker.dataSource = self
        genderField.inputView = genderPicker
        
        datePicker.datePickerMode = .date
        birthDayField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
        datePicker.limitYears()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firstNameField.text = data["firstName"]
        lastNameField.text = data["lastName"]
        phoneField.text = data["phone"]
        genderField.text = data["gender"]
        birthDayField.text = data["age"]
    }
    
    @IBAction func goToBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func goToChangePass() {
        let storyboardPass = UIStoryboard(name: "PassChange", bundle: nil)
        let vc = storyboardPass.instantiateViewController(withIdentifier: "PasswordEditViewController") as! PasswordEditViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        isa = true
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        birthDayField.text = dateFormatter.string(from: datePicker.date)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderField.text = genderData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderData[row]
    }
    
    func changeRegFormUI(textField: UITextField, label: UILabel) {
        textField.shake()
        label.textColor = .yellow
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.red.cgColor
    }
    
    func defaultRegFormUI(textField: UITextField, label: UILabel) {
        label.textColor = .white
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightText.cgColor
    }
    
    
    @IBAction func save() {
        if checkRegFormData() {
            let userId = UserDefaults.standard.string(forKey: "userId")
            ref.child("users").child(userId!).observeSingleEvent(of: .value, with: {[weak self] (snapshot) in
                let dict: NSDictionary = self!.data as NSDictionary
                self!.ref.child("users").child(userId!).setValue(dict)
                print("ok")
                UserDefaults.standard.set(self!.data, forKey: "user")
                UIApplication.appDelegate.user = User(user: self!.data)
                self!.navigationController?.popViewController(animated: true)
                
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Textfield delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if firstNameField.text == "" {
            firstNameField.becomeFirstResponder()
        } else if lastNameField.text == "" {
            lastNameField.becomeFirstResponder()
        } else if phoneField.text == "" {
            phoneField.becomeFirstResponder()
        } else if birthDayField.text == "" {
            birthDayField.becomeFirstResponder()
        } else if genderField.text == "" {
            genderField.becomeFirstResponder()
        } else {
            save()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let point = textField.superview!.frame.origin
        if point.y > scrollView.frame.height / 3  {
            if isa {
                isa = false
                UIView.animate(withDuration: 0.6) {
                    self.scrollView.setContentOffset(CGPoint(x: 0, y: point.y - 20 ), animated: true)
                    self.view.layoutIfNeeded()
                }
            }
        }
        activeTextField = textField
        switch textField {
        case firstNameField:
            firstNameLabel.text = "First Name"
            defaultRegFormUI(textField: firstNameField, label: firstNameLabel)
        case lastNameField:
            lastNameLabel.text = "Last Name"
            defaultRegFormUI(textField: lastNameField, label: lastNameLabel)
        case phoneField:
            phoneLabel.text = "Phone Number"
            defaultRegFormUI(textField: phoneField, label: phoneLabel)
        case birthDayField:
            birthDayLabel.text = "Birthday"
            defaultRegFormUI(textField: birthDayField, label: birthDayLabel)
        case genderField:
            genderLabel.text = "Gender"
            defaultRegFormUI(textField: genderField, label: genderLabel)
        default:
            return
        }
    }
    
    func checkRegFormData() -> Bool {
        var formChecked = true
        
        if  !(firstNameField.text?.isEmpty)! {
            data["firstName"] = firstNameField.text!
        } else {
            formChecked = false
            firstNameLabel.text = "Empty Name"
            changeRegFormUI(textField: firstNameField, label: firstNameLabel)
        }
        
        if  !(lastNameField.text?.isEmpty)! {
            data["lastName"] = lastNameField.text!
        } else {
            formChecked = false
            lastNameLabel.text = "Empty Last Name"
            changeRegFormUI(textField: lastNameField, label: lastNameLabel)
        }
        
        if  !(phoneField.text?.isEmpty)! {
            data["phone"] = phoneField.text!
        } else {
            formChecked = false
            phoneLabel.text = "Empty Phone Number"
            changeRegFormUI(textField: phoneField, label: phoneLabel)
        }
        
        if  !(birthDayField.text?.isEmpty)! {
            data["age"] = birthDayField.text
        } else {
            formChecked = false
            birthDayLabel.text = "Tap your Birthday"
            changeRegFormUI(textField: birthDayField, label: birthDayLabel)
        }
        
        if  !(genderField.text?.isEmpty)! {
            data["gender"] = genderField.text!
        } else {
            formChecked = false
            genderLabel.text = "Select Gender"
            changeRegFormUI(textField: genderField, label: genderLabel)
        }
        
        if formChecked && !(validData.values.contains(false)) {
            return true
        }
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if (textField.text?.isEmpty)!{
            lastSelectedTextField = textField
            textField.layer.borderColor = UIColor.red.cgColor
            return
        }
        
        switch textField {
        case phoneField:
            
            if textField.validatePhoneNumber(value: phoneField.text!) {
                validData["phone"] = true
            } else {
                validData["phone"] = false
                phoneLabel.text = "Wrong Phone Number"
                changeRegFormUI(textField: phoneField, label: phoneLabel)
            }
            
            
        case birthDayField:
            if textField.validateAge(birthDay: datePicker.date) {
                validData["birthDay"] = true
            } else {
                validData["birthDay"] = false
                birthDayLabel.text = "It`s 18+ game"
                changeRegFormUI(textField: birthDayField, label: birthDayLabel)
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
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.5) {
                self.bottomConstraint.constant -= keyboardSize.size.height
                self.view.layoutIfNeeded()
            }
        }
    }
}
