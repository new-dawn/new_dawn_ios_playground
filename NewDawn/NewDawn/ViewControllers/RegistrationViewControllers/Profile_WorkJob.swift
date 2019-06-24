//
//  Profile_WorkJob.swift
//  NewDawn
//
//  Created by macboy on 12/23/18.
//  Copyright © 2018 New Dawn. All rights reserved.
//

import UIKit

let JOBTITLE = "job_title"
let WORKPLACE = "employer"

class Profile_WorkJob: UIViewController {
    
    let VISIBLE = "work_visible"
    var visibleField = false
    
    @IBOutlet weak var workplaceTextField: UITextField!
    @IBOutlet weak var jobtitleTextField: UITextField!
    // @IBOutlet weak var visibleButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    
    func loadStoredFields() {
        if let workplace = localReadKeyValue(key: WORKPLACE) as? String {
            workplaceTextField.text = workplace
        }
        if let jobtitle = localReadKeyValue(key: JOBTITLE) as? String {
            jobtitleTextField.text = jobtitle
        }
        // if let visible = localReadKeyValue(key: VISIBLE) as? Bool {
            // visibleField = visible
            // Select the button if a user has already done so
            // if visibleField == true {
                // selectButton(button: visibleButton, text: "Visible")
            // }
        // }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        workplaceTextField.setBottomBorder()
        jobtitleTextField.setBottomBorder()
        continueButton.titleEdgeInsets = UIEdgeInsets(top: -20.0, left: 0.0, bottom: 0.0, right: 0.0)
        backButton.titleEdgeInsets = UIEdgeInsets(top: -20.0, left: 0.0, bottom: 0.0, right: 0.0)
        // polishUIButton(button: visibleButton)
        loadStoredFields()
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String,
                                     sender: Any?) -> Bool{
        if ((workplaceTextField.text?.isEmpty)! || (jobtitleTextField.text?.isEmpty)!) && identifier == "job_continue" {
            self.displayMessage(userMessage: "Cannot have empty field")
            return false
        }else{
            return true
        }
    }
    
    // @IBAction func visibleButtonTapped(_ sender: Any) {
        // if visibleField == true {
            // deselectButton(button: visibleButton, text: "Invisible")
            // visibleField = false
            // localStoreKeyValue(key: VISIBLE, value: false)
        // } else {
            // selectButton(button: visibleButton, text: "Visible")
            // visibleField = true
            // localStoreKeyValue(key: VISIBLE, value: true)
        // }
    // }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        localStoreKeyValue(key: WORKPLACE, value: workplaceTextField.text!)
        localStoreKeyValue(key: JOBTITLE, value: jobtitleTextField.text!)
    }
    
}
