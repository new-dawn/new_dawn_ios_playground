//
//  PreferenceSonViewControler.swift
//  NewDawn
//
//  Created by Junlin Liu on 4/17/19.
//  Copyright © 2019 New Dawn. All rights reserved.
//

import Foundation
import UIKit

class AgePrefViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    
    var age_pref: String = UNKNOWN
    let age_choices_from = [Int](18...60)
    let age_choices_to = [Int](18...60)
    var from_age = ""
    var to_age = ""
    @IBOutlet weak var age_range: UITextField!
    
    override func viewDidLoad() {
        age_range.setBottomBorder()
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(donePicker))
        toolbar.setItems([flexSpace, doneButton], animated: false)
//        toolbar.isUserInteractionEnabled = true
        
        let ageRangePicker = UIPickerView()
        age_range.inputView = ageRangePicker
        age_range.inputAccessoryView = toolbar
        ageRangePicker.delegate = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 1{
            return 1
        }else{
            return self.age_choices_from.count
        }
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 1{
            return "To"
        }else if component == 0{
            return String(age_choices_from[row])
        }else{
            return String(age_choices_to[row])
        }
    }
    
    @objc func donePicker() {
        age_range.text = self.from_age + " to " + self.to_age + " 岁"
        age_range.resignFirstResponder()
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0{
            let selected_from = pickerView.selectedRow(inComponent: 0)
            self.from_age = String(age_choices_from[selected_from])
        }else if component == 2{
            let selected_to = pickerView.selectedRow(inComponent: 2)
            self.to_age = String(age_choices_to[selected_to])
        }
    }
    
}
