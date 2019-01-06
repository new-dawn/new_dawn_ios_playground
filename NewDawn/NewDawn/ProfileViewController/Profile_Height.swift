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
    let heightPickerData = ["<140 cm", "140 cm", "141 cm"]
    
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
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(Profile_Education.donePicker))
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        // Degree Picker
        let heightPicker = UIPickerView()
        heightTextField.inputView = heightPicker
        heightTextField.inputAccessoryView = toolbar
        heightPicker.delegate = self
        
        // Do any additional setup after loading the view.
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
        if (heightTextField.text?.isEmpty)!  {
            displayMessage(userMessage: "Cannot have empty field")
        }
        localStoreKeyValue(key: HEIGHT, value: heightTextField.text!)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
