//
//  Profile_Drink.swift
//  NewDawn
//
//  Created by Junlin Liu on 12/27/18.
//  Copyright © 2018 New Dawn. All rights reserved.
//

import UIKit

class Profile_Drink: UIViewController {
    
    let DRINK = "drink"
    let FREQUENT_DRINK = "frequent"
    let NODRINK = "no"
    let SOCIAL_DRINK = "social"
    let UNKNOWN = "N/A"
    let VISIBLE = "drink_visible"
    var drink_pref: String? = nil
    var visible_state = false
    
    @IBOutlet weak var sociallyButton: UIButton!
    @IBOutlet weak var frequentlyButton: UIButton!
    @IBOutlet weak var noDrinkButton: UIButton!
    @IBOutlet weak var visibleButton: UIButton!
    
    func loadStoredFields() {
        // Select the buttons if a user has already done so
        if let drink = localReadKeyValue(key: DRINK) as? String{
            if drink == NODRINK{
                selectButton(button: noDrinkButton)
                drink_pref = NODRINK
            }
            else if drink == FREQUENT_DRINK{
                selectButton(button: frequentlyButton)
                drink_pref = FREQUENT_DRINK
            }
            else if drink == SOCIAL_DRINK{
                selectButton(button: sociallyButton)
                drink_pref = SOCIAL_DRINK
            }
        }
        if let drink_visible = localReadKeyValue(key: VISIBLE) as? Bool {
            let visibleField = drink_visible
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
        polishUIButton(button: noDrinkButton)
        polishUIButton(button: visibleButton)
        loadStoredFields()
    }
    
    @IBAction func visibeButtonTapped(_ sender: Any) {
        if visible_state == true {
            deselectButton(button: visibleButton, text: "Invisible")
            visible_state = false
        } else {
            selectButton(button: visibleButton, text: "Visible")
            visible_state = true
        }
    }
    
    
    @IBAction func noDrinkButtonTapped(_ sender: Any) {
        if drink_pref == NODRINK {
            deselectButton(button: noDrinkButton)
            drink_pref = nil
        } else {
            selectButton(button: noDrinkButton)
            deselectButtons(buttons: [sociallyButton,frequentlyButton])
            drink_pref = NODRINK
        }
    }
    
    @IBAction func frequentButtonTapped(_ sender: Any) {
        if drink_pref == FREQUENT_DRINK {
            deselectButton(button: frequentlyButton)
            drink_pref = nil
        } else {
            selectButton(button: frequentlyButton)
            deselectButtons(buttons: [sociallyButton,noDrinkButton])
            drink_pref = FREQUENT_DRINK
        }
    }
    
    @IBAction func sociallyButtonTapped(_ sender: Any) {
        if drink_pref == SOCIAL_DRINK {
            deselectButton(button: sociallyButton)
            drink_pref = nil
        } else {
            selectButton(button: sociallyButton)
            deselectButtons(buttons: [frequentlyButton,noDrinkButton])
            drink_pref = SOCIAL_DRINK
        }
    }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        if drink_pref != nil{
            localStoreKeyValue(key: DRINK, value: drink_pref!)
        }else{
            localStoreKeyValue(key: DRINK, value: UNKNOWN)
        }
        localStoreKeyValue(key: VISIBLE, value: visible_state)
    }
    
}
