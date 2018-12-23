//
//  ProfileGNBViewController.swift
//  NewDawn
//
//  Created by 汤子毅 on 2018/12/21.
//  Copyright © 2018 New Dawn. All rights reserved.
//

import UIKit

class ProfileGNBViewController: UIViewController {

    @IBOutlet weak var womenButton: UIButton!
    @IBOutlet weak var menButton: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    
    let datePicker = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()
        polishUIButton(button: womenButton)
        polishUIButton(button: menButton)
        polishTextField(textField: nameTextField)
        polishTextField(textField: birthdayTextField)
        showDatePicker()
    }
    
    @IBAction func womenButtonTapped(_ sender: Any) {
        selectButton(button: womenButton)
        deselectButton(button: menButton)
        localStoreKeyValue(key: "sex", value: "W")
    }
    @IBAction func menButtonTapped(_ sender: Any) {
        selectButton(button: menButton)
        deselectButton(button: womenButton)
        localStoreKeyValue(key: "sex", value: "M")
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        if (nameTextField.text?.isEmpty)!
            || (birthdayTextField.text?.isEmpty)! {
            displayMessage(userMessage: "Cannot have empty field")
        }
        // Store Name, Birthday locally
        localStoreKeyValue(key: "name", value: nameTextField.text!)
        localStoreKeyValue(key: "birthday", value: birthdayTextField.text!)
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
