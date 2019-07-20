//
//  ProfileGNBViewController.swift
//  NewDawn
//
//  Created by 汤子毅 on 2018/12/21.
//  Copyright © 2018 New Dawn. All rights reserved.
//

import UIKit
import Mixpanel

let FIRSTNAME = "first_name"
let LASTNAME = "last_name"
let BIRTHDAY = "birthday"
let GENDER = "gender"

class ProfileGNBViewController: UIViewController {
    let MAN = "M"
    let WOMAN = "W"
    var gender = UNKNOWN

    @IBOutlet weak var womanButton: UIButton!
    @IBOutlet weak var manButton: UIButton!
    
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    
    let datePicker = UIDatePicker()
    
    // Load fields that user has already filled in
    func loadStoredFields() {
        if let firstname = localReadKeyValue(key: FIRSTNAME) as? String {
            firstnameTextField.text = firstname
        }
        if let lastname = localReadKeyValue(key: LASTNAME) as? String {
            lastnameTextField.text = lastname
        }
        if let birthday = localReadKeyValue(key: BIRTHDAY) as? String {
            birthdayTextField.text = birthday
        }
        if let stored_gender = localReadKeyValue(key: GENDER) as? String {
            gender = stored_gender
            if gender == MAN {
                selectManButton(button: manButton)
            } else {
                selectWomanButton(button: womanButton)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        Mixpanel.mainInstance().time(event: REGISTRATION_DURATION)
        polishGenderButton(button: womanButton)
        polishGenderButton(button: manButton)

        firstnameTextField.setBottomBorder()
        lastnameTextField.setBottomBorder()
        birthdayTextField.setBottomBorder()
        //move text 20 pixels up
        continueButton.titleEdgeInsets = UIEdgeInsets(top: -20.0, left: 0.0, bottom: 0.0, right: 0.0)
        loadStoredFields()
        showDatePicker()
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        let loc = Locale(identifier: "zh_Hans_CN")
        self.datePicker.locale = loc
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String,
                                     sender: Any?) -> Bool{
        if (firstnameTextField.text?.isEmpty)! ||
            (lastnameTextField.text?.isEmpty)! ||
            (birthdayTextField.text?.isEmpty)! ||
            gender == UNKNOWN{
            self.displayMessage(userMessage: "Cannot have empty field")
            return false
        }else{
            return true
        }
    }
    
    @IBAction func womanButtonTapped(_ sender: Any) {
        selectWomanButton(button: womanButton)
        deselectButton(button: manButton)
        gender = WOMAN
        localStoreKeyValue(key: GENDER, value: gender)
    }
    @IBAction func manButtonTapped(_ sender: Any) {
        selectManButton(button: manButton)
        deselectButton(button: womanButton)
        gender = MAN
        localStoreKeyValue(key: GENDER, value: gender)
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        
        if shouldPerformSegue(withIdentifier: "profileGNG_continue", sender: self){
            performSegue(withIdentifier: "profileGNG_continue", sender: self)
            // Store Name, Birthday locally
            localStoreKeyValue(key: FIRSTNAME, value: firstnameTextField.text!)
            localStoreKeyValue(key: LASTNAME, value: lastnameTextField.text!)
            localStoreKeyValue(key: BIRTHDAY, value: birthdayTextField.text!)
            }
    }
    
    // A helper function to show date picker
    func showDatePicker() {
        //Formate Date
        datePicker.datePickerMode = .date
        
        //Minimum 18 years old
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        birthdayTextField.inputAccessoryView = toolbar
        birthdayTextField.inputView = datePicker
    }
    
    @objc func donedatePicker(dateField: UITextField){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        birthdayTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    func selectWomanButton(button: UIButton){
        let color = UIColor(red:241/255, green:78/255, blue:78/255, alpha:1)
        button.setTitleColor(.white, for: .normal)
        button.tintColor = UIColor.white
        button.layer.borderColor = color.cgColor
        button.layer.backgroundColor = color.cgColor
    }
    
    func selectManButton(button: UIButton){
        let color = UIColor(red:22/255, green:170/255, blue:184/255, alpha:1)
        button.setTitleColor(.white, for: .normal)
        button.tintColor = UIColor.white
        button.layer.borderColor = color.cgColor
        button.layer.backgroundColor = color.cgColor
    }
    
    func polishGenderButton(button: UIButton) -> Void {
        button.layer.cornerRadius = 13
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor(red:151/255, green:151/255, blue:151/255, alpha:1).cgColor
        button.layer.masksToBounds = true
    }


}
