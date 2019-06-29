//
//  Profile_DrinkSmoke.swift
//  NewDawn
//
//  Created by macboy on 12/23/18.
//  Copyright © 2018 New Dawn. All rights reserved.
//

import UIKit

let SMOKE = "smoke"

class Profile_Smoke: UIViewController {

    let FREQUENT_SMOKE = "经常抽"
    let NOSMOKE = "不抽"
    let SOCIAL_SMOKE = "偶尔抽"
    let UNKNOWN = "N/A"
    // let VISIBLE = "smoke_visible"
    var smoke_pref: String? = nil
    // var visible_state = false
    
    @IBOutlet weak var sociallyButton: UIButton!
    @IBOutlet weak var frequentlyButton: UIButton!
    @IBOutlet weak var noSmokeButton: UIButton!
    // @IBOutlet weak var visibleButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    
    func loadStoredFields() {
        // Select the buttons if a user has already done so
        if let smoke = localReadKeyValue(key: SMOKE) as? String{
            if smoke == NOSMOKE{
                selectSmokeButton(button: noSmokeButton)
                smoke_pref = NOSMOKE
            }
            else if smoke == FREQUENT_SMOKE{
                selectSmokeButton(button: frequentlyButton)
                smoke_pref = FREQUENT_SMOKE
            }
            else if smoke == SOCIAL_SMOKE{
                selectSmokeButton(button: sociallyButton)
                smoke_pref = SOCIAL_SMOKE
            }
        }
        
        // if let smoke_visible = localReadKeyValue(key: VISIBLE) as? Bool {
            // let visibleField = smoke_visible
            // if visibleField == true {
                // selectButton(button: visibleButton, text: "Visible")
                // visible_state = true
            // }
        // }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        polishSmokeButton(button: sociallyButton)
        polishSmokeButton(button: frequentlyButton)
        polishSmokeButton(button: noSmokeButton)
        // polishUIButton(button: visibleButton)
        loadStoredFields()
        continueButton.titleEdgeInsets = UIEdgeInsets(top: -20.0, left: 0.0, bottom: 0.0, right: 0.0)
        backButton.titleEdgeInsets = UIEdgeInsets(top: -20.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    // @IBAction func visibleButtonTapped(_ sender: Any) {
        // if visible_state == true {
            // deselectButton(button: visibleButton, text: "Invisible")
            // visible_state = false
        // } else {
            // selectButton(button: visibleButton, text: "Visible")
            // visible_state = true
        // }
    // }
    
    @IBAction func noSmokeButtonTapped(_ sender: Any) {
        if smoke_pref == NOSMOKE {
            deselectButton(button: noSmokeButton)
            smoke_pref = nil
        } else {
            selectSmokeButton(button: noSmokeButton)
            deselectButtons(buttons: [sociallyButton,frequentlyButton])
            smoke_pref = NOSMOKE
        }
    }
    
    @IBAction func frequentButtonTapped(_ sender: Any) {
        if smoke_pref == FREQUENT_SMOKE {
            deselectButton(button: frequentlyButton)
            smoke_pref = nil
        } else {
            selectSmokeButton(button: frequentlyButton)
            deselectButtons(buttons: [sociallyButton,noSmokeButton])
            smoke_pref = FREQUENT_SMOKE
        }
    }
    
    @IBAction func sociallyButtonTapped(_ sender: Any) {
        if smoke_pref == SOCIAL_SMOKE {
            deselectButton(button: sociallyButton)
            smoke_pref = nil
        } else {
            selectSmokeButton(button: sociallyButton)
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
        // localStoreKeyValue(key: VISIBLE, value: visible_state)
        }
    
    func polishSmokeButton(button: UIButton) -> Void {
        button.layer.cornerRadius = 13
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor(red:151/255, green:151/255, blue:151/255, alpha:1).cgColor
        button.layer.masksToBounds = true
    }
    
    func selectSmokeButton(button: UIButton){
        let color = UIColor(red:22/255, green:170/255, blue:184/255, alpha:1)
        button.setTitleColor(.white, for: .normal)
        button.tintColor = UIColor.white
        button.layer.borderColor = color.cgColor
        button.layer.backgroundColor = color.cgColor
    }
    
}

