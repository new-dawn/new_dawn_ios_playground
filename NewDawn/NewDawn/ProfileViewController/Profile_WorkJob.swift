//
//  Profile_WorkJob.swift
//  NewDawn
//
//  Created by macboy on 12/23/18.
//  Copyright © 2018 New Dawn. All rights reserved.
//

import UIKit

class Profile_WorkJob: UIViewController {
    
    let JOBTITLE = "job_title"
    let VISIBLE = "work_visible"
    let WORKPLACE = "workplace"
    var visibleField = false
    
    @IBOutlet weak var workplaceTextField: UITextField!
    @IBOutlet weak var jobtitleTextField: UITextField!
    @IBOutlet weak var visibleButton: UIButton!
    
    
    func loadStoredFields() {
        if let workplace = localReadKeyValue(key: WORKPLACE) as? String {
            workplaceTextField.text = workplace
        }
        if let jobtitle = localReadKeyValue(key: JOBTITLE) as? String {
            jobtitleTextField.text = jobtitle
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
        polishTextField(textField: workplaceTextField)
        polishTextField(textField: jobtitleTextField)
        polishUIButton(button: visibleButton)
        loadStoredFields()
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
        if (workplaceTextField.text?.isEmpty)! || (jobtitleTextField.text?.isEmpty)! {
            displayMessage(userMessage: "Cannot have empty field")
        }
        localStoreKeyValue(key: WORKPLACE, value: workplaceTextField.text!)
        localStoreKeyValue(key: JOBTITLE, value: jobtitleTextField.text!)
    }
    
}
