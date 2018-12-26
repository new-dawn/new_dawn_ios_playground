//
//  Profile_DrinkSmoke.swift
//  NewDawn
//
//  Created by macboy on 12/23/18.
//  Copyright © 2018 New Dawn. All rights reserved.
//

import UIKit

// State contains "no", "frequent", "social"
class SmokePref{
    var state = ""
}

class Profile_Smoke: UIViewController {
    var visible = false
    var smoke_pref = SmokePref()
    
    @IBOutlet weak var sociallyButton: UIButton!
    @IBOutlet weak var frequentlyButton: UIButton!
    @IBOutlet weak var noSmokeButton: UIButton!
    @IBOutlet weak var visibleButton: UIButton!
    
    
    func loadStoredFields() {
        // Select the buttons if a user has already done so
        if let smoke = localReadKeyValue(key: "smoke") as? String{
            if smoke == "no"{
                selectButton(button: noSmokeButton)
                smoke_pref.state = "no"
            }
            else if smoke == "frequent"{
                selectButton(button: frequentlyButton)
                smoke_pref.state = "frequent"
            }
            else if smoke == "social"{
                selectButton(button: sociallyButton)
                smoke_pref.state = "social"
            }
        }
        
        if let smoke_visible = localReadKeyValue(key: "smoke_visible") as? Bool {
            let visibleField = smoke_visible
            if visibleField == true {
                selectButton(button: visibleButton, text: "Visible")
                visible = true
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        polishUIButton(button: sociallyButton)
        polishUIButton(button: frequentlyButton)
        polishUIButton(button: noSmokeButton)
        polishUIButton(button: visibleButton)
        loadStoredFields()
    }
    
    @IBAction func visibleButtonTapped(_ sender: Any) {
        if visible == true {
            deselectButton(button: visibleButton, text: "Invisible")
            visible = false
        } else {
            selectButton(button: visibleButton, text: "Visible")
            visible = true
        }
    }
    
    @IBAction func noSmokeButtonTapped(_ sender: Any) {
        if smoke_pref.state == "no" {
            deselectButton(button: noSmokeButton)
            smoke_pref.state = ""
        } else {
            selectButton(button: noSmokeButton)
            deselectButtons(buttons: [sociallyButton,frequentlyButton])
            smoke_pref.state = "no"
        }
    }
    
    @IBAction func frequentButtonTapped(_ sender: Any) {
        if smoke_pref.state == "frequent" {
            deselectButton(button: frequentlyButton)
            smoke_pref.state = ""
        } else {
            selectButton(button: frequentlyButton)
            deselectButtons(buttons: [sociallyButton,noSmokeButton])
            smoke_pref.state = "frequent"
        }
    }
    
    @IBAction func sociallyButtonTapped(_ sender: Any) {
        if smoke_pref.state == "social" {
            deselectButton(button: sociallyButton)
            smoke_pref.state = ""
        } else {
            selectButton(button: sociallyButton)
            deselectButtons(buttons: [frequentlyButton,noSmokeButton])
            smoke_pref.state = "social"
        }
    }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        
            localStoreKeyValue(key: "smoke", value: smoke_pref.state)
            localStoreKeyValue(key: "smoke_visible", value: visible)
        
    }
}
