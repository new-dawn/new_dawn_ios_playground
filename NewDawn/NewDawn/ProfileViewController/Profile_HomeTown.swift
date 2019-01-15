//
//  Profile_HomeTown.swift
//  NewDawn
//
//  Created by macboy on 12/23/18.
//  Copyright © 2018 New Dawn. All rights reserved.
//

import UIKit

let HOMETOWN = "hometown"

class Profile_HomeTown: UIViewController {
    
    
    /* Constant String Keys*/
    let VISIBLE = "hometown_visible"
    
    /* Constrains */
    
    var visibleField = false

    @IBOutlet weak var homeTwonTextField: UITextField!
    @IBOutlet weak var visibleButton: UIButton!
    
    func loadStoredFields() {
        if let hometown = localReadKeyValue(key: HOMETOWN) as? String {
            homeTwonTextField.text = hometown
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
        polishTextField(textField: homeTwonTextField)
        polishUIButton(button: visibleButton)
        loadStoredFields()
        
    }
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        self.view.endEditing(true)
//        return false
//    }
    
    
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
        if (homeTwonTextField.text?.isEmpty)!  {
            displayMessage(userMessage: "Cannot have empty field")
        }
        localStoreKeyValue(key: HOMETOWN, value: homeTwonTextField.text!)
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
