//
//  Profile_HomeTown.swift
//  NewDawn
//
//  Created by macboy on 12/23/18.
//  Copyright © 2018 New Dawn. All rights reserved.
//

import UIKit

let HOMETOWN = "hometown"

class Profile_HomeTown: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let VISIBLE = "hometown_visible"
    let locationPickerData = ["纽约", "波士顿"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return locationPickerData.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return locationPickerData[row]
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        hometownTextField.text = locationPickerData[row]
    }
    
    
    @IBOutlet weak var hometownTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    func loadStoredFields() {
        if let hometown = localReadKeyValue(key: HOMETOWN) as? String {
            hometownTextField.text = hometown
        }
    }
    
    @objc func donePicker() {
        hometownTextField.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hometownTextField.setBottomBorder()
        continueButton.titleEdgeInsets = UIEdgeInsets(top: -20.0, left: 0.0, bottom: 0.0, right: 0.0)
        backButton.titleEdgeInsets = UIEdgeInsets(top: -20.0, left: 0.0, bottom: 0.0, right: 0.0)
        loadStoredFields()
        
        // Picker Toolbar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(Profile_HomeTown.donePicker))
        toolbar.setItems([flexSpace, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        // Location Picker
        let locationPicker = UIPickerView()
        hometownTextField.inputView = locationPicker
        hometownTextField.inputAccessoryView = toolbar
        locationPicker.delegate = self
        
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool{
        if (hometownTextField.text?.isEmpty)! {
            self.displayMessage(userMessage: "Cannot have empty field")
            return false
        }else{
            return true
        }
    }

    @IBAction func nextButtonTapped(_ sender: Any) {
        localStoreKeyValue(key: HOMETOWN, value: hometownTextField.text!)
        localStoreKeyValue(key: VISIBLE, value: true)
    }
    
}
