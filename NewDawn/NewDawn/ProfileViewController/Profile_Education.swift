//
//  Profile_Education.swift
//  NewDawn
//
//  Created by macboy on 12/23/18.
//  Copyright © 2018 New Dawn. All rights reserved.
//

import UIKit

class Profile_Education: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Constant string keys
    let SCHOOL = "school"
    let DEGREE = "degree"
    let VISIBLE = "edu_visible"
    
    var visibleField = false
    let degreePickerData = [String](arrayLiteral: "", "High School", "Undergrad", "Grad", "PhD")
    
    @IBOutlet weak var degreeTextField: UITextField!
    @IBOutlet weak var schoolTextField: UITextField!
    @IBOutlet weak var visibleButton: UIButton!
    
    // Load fields that user has already filled in
    func loadStoredFields() {
        if let school = localReadKeyValue(key: SCHOOL) as? String {
            schoolTextField.text = school
        }
        if let degree = localReadKeyValue(key: DEGREE) as? String {
            degreeTextField.text = degree
        }
        if let visible = localReadKeyValue(key: VISIBLE) as? Bool {
            visibleField = visible
            // Select the button if a user has already done so
            if visibleField == true {
                selectButton(button: visibleButton, text: "Visible")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        polishTextField(textField: schoolTextField)
        polishTextField(textField: degreeTextField)
        polishUIButton(button: visibleButton)
        loadStoredFields()
        
        // Picker Toolbar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(Profile_Education.donePicker))
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        // Degree Picker
        let degreePicker = UIPickerView()
        degreeTextField.inputView = degreePicker
        degreeTextField.inputAccessoryView = toolbar
        degreePicker.delegate = self
    }
    
    @IBAction func visibleButtonTapped(_ sender: Any) {
        if visibleField == true {
            deselectButton(button: visibleButton, text: "Invisible")
            visibleField = false
            localStoreKeyValue(key: VISIBLE, value: false)
        } else {
            selectButton(button: visibleButton, text: "Visible")
            visibleField = true
            localStoreKeyValue(key: VISIBLE, value: true)
        }
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        if (schoolTextField.text?.isEmpty)! || (degreeTextField.text?.isEmpty)! {
            displayMessage(userMessage: "Cannot have empty field")
        }
        localStoreKeyValue(key: SCHOOL, value: schoolTextField.text!)
        localStoreKeyValue(key: DEGREE, value: degreeTextField.text!)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return degreePickerData.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return degreePickerData[row]
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        degreeTextField.text = degreePickerData[row]
    }
    
    @objc func donePicker() {
        degreeTextField.resignFirstResponder()
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
