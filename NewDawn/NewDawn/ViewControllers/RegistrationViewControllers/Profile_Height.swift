//
//  Profile_Height.swift
//  NewDawn
//
//  Created by macboy on 12/23/18.
//  Copyright © 2018 New Dawn. All rights reserved.
//

import UIKit

let HEIGHT = "height"

class Profile_Height: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    /* Constant String Keys*/
    let VISIBLE = "height_visible"
    
    /* Constrains */
    
    var visibleField = false
    let heightPickerData = Profile_Height.heightGenerator(minHeight: 140, maxHeight: 250)
    
    @IBOutlet weak var heightTextField: UITextField!
    
    @IBOutlet weak var visibleButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        polishTextField(textField: heightTextField)
        polishUIButton(button: visibleButton)
        loadStoredFields()
        
        // Picker Toolbar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(Profile_Education.donePicker))
        toolbar.setItems([flexSpace, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        // Degree Picker
        let heightPicker = UIPickerView()
        heightTextField.inputView = heightPicker
        heightTextField.inputAccessoryView = toolbar
        heightPicker.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String,
                                     sender: Any?) -> Bool{
        if (heightTextField.text?.isEmpty)! {
            self.displayMessage(userMessage: "Cannot have empty field")
            return false
        }else{
            return true
        }
    }
    
    func loadStoredFields() {
        if let height = localReadKeyValue(key: HEIGHT) as? String {
            heightTextField.text = height
        }
        if let visible = localReadKeyValue(key: VISIBLE) as? Bool {
            visibleField = visible
            // Select the button if a user has already done so
            if visibleField == true {
                selectButton(button: visibleButton, text: "Visible")
            }
        }
    }
    
    @IBAction func visibleBUttonTapped(_ sender: Any) {
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

    
    @IBAction func nextButtonAction(_ sender: Any) {
        if shouldPerformSegue(withIdentifier: "height_continue", sender: self){
            performSegue(withIdentifier: "height_continue", sender: self)
            localStoreKeyValue(key: HEIGHT, value: heightTextField.text!)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return heightPickerData.count
    }

    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return heightPickerData[row]
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        heightTextField.text = heightPickerData[row]
    }
    
    @objc func donePicker() {
        heightTextField.resignFirstResponder()
    }
    
    class func heightGenerator(minHeight: Int, maxHeight: Int) -> [String]{
        let heights_int = [Int](minHeight...maxHeight)
        var heightStringArray = heights_int.map { String($0) + " cm"}
        let min_value = "<" + String(minHeight) + " cm"
        let max_value = ">" + String(maxHeight) + " cm"
        heightStringArray.insert(min_value, at: 0)
        heightStringArray.insert(max_value, at: heightStringArray.count)
        return heightStringArray
    }
}
