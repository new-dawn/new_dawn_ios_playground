//
//  Profile_Location
//  NewDawn
//
//  Created by 汤子毅 on 12/23/18.
//  Copyright © 2018 New Dawn. All rights reserved.
//

import UIKit

let LOCATION = "location"
let NEWYORK = "纽约"
let BOSTON = "波士顿"
let OTHERS = "其他"

class Profile_Location: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let locationPickerData = [NEWYORK, BOSTON, OTHERS]
    
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
        locationTextField.text = locationPickerData[row]
    }
    
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    
func loadStoredFields() {
        if let location = localReadKeyValue(key: LOCATION) as? String {
            locationTextField.text = location
        }
    }
    
    @objc func donePicker() {
        locationTextField.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTextField.setBottomBorder()
        continueButton.titleEdgeInsets = UIEdgeInsets(top: -20.0, left: 0.0, bottom: 0.0, right: 0.0)
        backButton.titleEdgeInsets = UIEdgeInsets(top: -20.0, left: 0.0, bottom: 0.0, right: 0.0)
        loadStoredFields()
        
        // Picker Toolbar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(donePicker))
        toolbar.setItems([flexSpace, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        // Location Picker
        let locationPicker = UIPickerView()
        locationTextField.inputView = locationPicker
        locationTextField.inputAccessoryView = toolbar
        locationPicker.delegate = self
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool{
        if (locationTextField.text?.isEmpty)! && identifier == "location_continue" {
            self.displayMessage(userMessage: "Cannot have empty field")
            return false
        }else{
            return true
        }
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        localStoreKeyValue(key: LOCATION, value: locationTextField.text!)
    }
}
