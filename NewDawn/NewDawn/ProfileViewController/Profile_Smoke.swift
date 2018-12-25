//
//  Profile_DrinkSmoke.swift
//  NewDawn
//
//  Created by macboy on 12/23/18.
//  Copyright © 2018 New Dawn. All rights reserved.
//

import UIKit

class Profile_Smoke: UIViewController {
    var visible = false
    var smoke_pref = ["smoke_no":false, "smoke_socially":false, "smoke_frequently":false]
    
    @IBOutlet weak var sociallyButton: UIButton!
    @IBOutlet weak var frequentlyButton: UIButton!
    @IBOutlet weak var noSmokeButton: UIButton!
    @IBOutlet weak var visibleButton: UIButton!
    
    
    func loadStoredFields() {
        if localReadKeyValue(key: "smoke_no") != nil{
            selectButton(button: noSmokeButton)
        }else if localReadKeyValue(key: "smoke_socially") != nil{
            selectButton(button: sociallyButton)
        }else if localReadKeyValue(key: "smoke_frequently") != nil{
            selectButton(button: frequentlyButton)
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
        if smoke_pref["smoke_no"] == true {
            deselectButton(button: noSmokeButton)
            smoke_pref["smoke_no"] = false
        } else {
            selectButton(button: noSmokeButton)
            deselectButtons(buttons: [sociallyButton,frequentlyButton])
            smoke_pref["smoke_no"] = true
            smoke_pref["smoke_socially"] = false
            smoke_pref["smoke_frequently"] = false
        }
    }
    
    @IBAction func frequentButtonTapped(_ sender: Any) {
        if smoke_pref["smoke_frequently"] == true {
            deselectButton(button: frequentlyButton)
            smoke_pref["smoke_frequently"] = false
        } else {
            selectButton(button: frequentlyButton)
            deselectButtons(buttons: [sociallyButton,noSmokeButton])
            smoke_pref["smoke_no"] = false
            smoke_pref["smoke_socially"] = false
            smoke_pref["smoke_frequently"] = true
        }
    }
    
    @IBAction func sociallyButtonTapped(_ sender: Any) {
        if smoke_pref["smoke_socially"] == true {
            deselectButton(button: sociallyButton)
            smoke_pref["smoke_socially"] = false
        } else {
            selectButton(button: sociallyButton)
            deselectButtons(buttons: [frequentlyButton,noSmokeButton])
            smoke_pref["smoke_no"] = false
            smoke_pref["smoke_socially"] = true
            smoke_pref["smoke_frequently"] = false
        }
    }
    
    @IBAction func continueButtonTapped(_ sender: Any) {

            if (smoke_pref["smoke_no"] == true){
                localStoreKeyValue(key: "smoke_no", value: smoke_pref["smoke_no"]!)
            }
            if (smoke_pref["smoke_socially"] == true){
                localStoreKeyValue(key: "smoke_socially", value: smoke_pref["smoke_socially"]!)
            }
            if (smoke_pref["smoke_frequently"] == true){
                localStoreKeyValue(key: "smoke_frequently", value: smoke_pref["smoke_frequently"]!)
            }
            localStoreKeyValue(key: "smoke_visible", value: visible)
        
    }
}
