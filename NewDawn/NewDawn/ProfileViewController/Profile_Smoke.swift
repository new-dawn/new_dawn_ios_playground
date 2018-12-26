//
//  Profile_DrinkSmoke.swift
//  NewDawn
//
//  Created by macboy on 12/23/18.
//  Copyright © 2018 New Dawn. All rights reserved.
//

import UIKit

class Profile_Smoke: UIViewController {
    var visible = true
    var smoke_pref = ["smoke":""]
    
    @IBOutlet weak var sociallyButton: UIButton!
    @IBOutlet weak var frequentlyButton: UIButton!
    @IBOutlet weak var noSmokeButton: UIButton!
    @IBOutlet weak var visibleButton: UIButton!
    
    
    func loadStoredFields() {
        if let smoke = localReadKeyValue(key: "smoke") as? String{
            if smoke == "no"{
                selectButton(button: noSmokeButton)
            }
            else if smoke == "frequent"{
                selectButton(button: frequentlyButton)
            }
            else if smoke == "social"{
                selectButton(button: sociallyButton)
            }
        }
        if let visible = localReadKeyValue(key: "smoke_visible") as? Bool {
            let visibleField = visible
            // Select the button if a user has already done so
            if visibleField == true {
                selectButton(button: visibleButton, text: "Visible")
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
        if smoke_pref["smoke"] == "no" {
            deselectButton(button: noSmokeButton)
            smoke_pref["smoke"] = ""
        } else {
            selectButton(button: noSmokeButton)
            deselectButtons(buttons: [sociallyButton,frequentlyButton])
            smoke_pref["smoke"] = "no"
        }
    }
    
    @IBAction func frequentButtonTapped(_ sender: Any) {
        if smoke_pref["smoke"] == "frequent" {
            deselectButton(button: frequentlyButton)
            smoke_pref["smoke"] = ""
        } else {
            selectButton(button: frequentlyButton)
            deselectButtons(buttons: [sociallyButton,noSmokeButton])
            smoke_pref["smoke"] = "frequent"
        }
    }
    
    @IBAction func sociallyButtonTapped(_ sender: Any) {
        if smoke_pref["smoke"] == "social" {
            deselectButton(button: sociallyButton)
            smoke_pref["smoke"] = ""
        } else {
            selectButton(button: sociallyButton)
            deselectButtons(buttons: [frequentlyButton,noSmokeButton])
            smoke_pref["smoke"] = "social"
        }
    }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        
            localStoreKeyValue(key: "smoke", value: smoke_pref["smoke"]!)
            localStoreKeyValue(key: "smoke_visible", value: visible)
        
    }
}
