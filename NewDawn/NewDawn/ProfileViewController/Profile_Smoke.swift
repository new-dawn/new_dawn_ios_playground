//
//  Profile_DrinkSmoke.swift
//  NewDawn
//
//  Created by macboy on 12/23/18.
//  Copyright © 2018 New Dawn. All rights reserved.
//

import UIKit


class Profile_Smoke: UIViewController {
    
    let FREQUENT_SMOKE = "frequent"
    let NOSMOKE = "no"
    let SMOKE = "smoke"
    let SOCIAL_SMOKE = "social"
    let UNKNOWN = "UNKNOWN"
    let VISIBLE = "smoke_visible"
    var smoke_pref: String? = nil
    var visible_state = false
    
    @IBOutlet weak var sociallyButton: UIButton!
    @IBOutlet weak var frequentlyButton: UIButton!
    @IBOutlet weak var noSmokeButton: UIButton!
    @IBOutlet weak var visibleButton: UIButton!
    
    
    func loadStoredFields() {
        // Select the buttons if a user has already done so
        if let smoke = localReadKeyValue(key: SMOKE) as? String{
            if smoke == NOSMOKE{
                selectButton(button: noSmokeButton)
                smoke_pref = NOSMOKE
            }
            else if smoke == FREQUENT_SMOKE{
                selectButton(button: frequentlyButton)
                smoke_pref = FREQUENT_SMOKE
            }
            else if smoke == SOCIAL_SMOKE{
                selectButton(button: sociallyButton)
                smoke_pref = SOCIAL_SMOKE
            }
        }
        
        if let smoke_visible = localReadKeyValue(key: VISIBLE) as? Bool {
            let visibleField = smoke_visible
            if visibleField == true {
                selectButton(button: visibleButton, text: "Visible")
                visible_state = true
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
        if visible_state == true {
            deselectButton(button: visibleButton, text: "Invisible")
            visible_state = false
        } else {
            selectButton(button: visibleButton, text: "Visible")
            visible_state = true
        }
    }
    
    @IBAction func noSmokeButtonTapped(_ sender: Any) {
        if smoke_pref == NOSMOKE {
            deselectButton(button: noSmokeButton)
            smoke_pref = nil
        } else {
            selectButton(button: noSmokeButton)
            deselectButtons(buttons: [sociallyButton,frequentlyButton])
            smoke_pref = NOSMOKE
        }
    }
    
    @IBAction func frequentButtonTapped(_ sender: Any) {
        if smoke_pref == FREQUENT_SMOKE {
            deselectButton(button: frequentlyButton)
            smoke_pref = nil
        } else {
            selectButton(button: frequentlyButton)
            deselectButtons(buttons: [sociallyButton,noSmokeButton])
            smoke_pref = FREQUENT_SMOKE
        }
    }
    
    @IBAction func sociallyButtonTapped(_ sender: Any) {
        if smoke_pref == SOCIAL_SMOKE {
            deselectButton(button: sociallyButton)
            smoke_pref = nil
        } else {
            selectButton(button: sociallyButton)
            deselectButtons(buttons: [frequentlyButton,noSmokeButton])
            smoke_pref = SOCIAL_SMOKE
        }
    }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        
        if smoke_pref != nil{
            localStoreKeyValue(key: SMOKE, value: smoke_pref!)
        }else{
            localStoreKeyValue(key: SMOKE, value: UNKNOWN)
        }
        localStoreKeyValue(key: VISIBLE, value: visible_state)

    }
}
