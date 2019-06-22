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
    
    //    var visibleField = false
    
    @IBOutlet weak var hometownTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    func loadStoredFields() {
        if let hometown = localReadKeyValue(key: HOMETOWN) as? String {
            hometownTextField.text = hometown
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hometownTextField.setBottomBorder()
        continueButton.titleEdgeInsets = UIEdgeInsets(top: -20.0, left: 0.0, bottom: 0.0, right: 0.0)
        backButton.titleEdgeInsets = UIEdgeInsets(top: -20.0, left: 0.0, bottom: 0.0, right: 0.0)
        loadStoredFields()
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool{
        if (hometownTextField.text?.isEmpty)! && identifier == "hometown_continue" {
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
