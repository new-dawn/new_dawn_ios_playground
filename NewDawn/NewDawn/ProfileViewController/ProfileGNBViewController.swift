//
//  ProfileGNBViewController.swift
//  NewDawn
//
//  Created by 汤子毅 on 2018/12/21.
//  Copyright © 2018 New Dawn. All rights reserved.
//

import UIKit

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
                selectButton(button: manButton)
            } else {
                selectButton(button: womanButton)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        polishUIButton(button: womanButton)
        polishUIButton(button: manButton)
        polishTextField(textField: firstnameTextField)
        polishTextField(textField: lastnameTextField)
        polishTextField(textField: birthdayTextField)
        loadStoredFields()
        showDatePicker()
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
        selectButton(button: womanButton)
        deselectButton(button: manButton)
        gender = WOMAN
        localStoreKeyValue(key: GENDER, value: gender)
    }
    @IBAction func manButtonTapped(_ sender: Any) {
        selectButton(button: manButton)
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
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        birthdayTextField.inputAccessoryView = toolbar
        birthdayTextField.inputView = datePicker
    }
    
    @objc func donedatePicker(dateField: UITextField){
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        birthdayTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
