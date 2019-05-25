//
//  Profile_Drink.swift
//  NewDawn
//
//  Created by Junlin Liu on 12/27/18.
//  Copyright © 2018 New Dawn. All rights reserved.
//

import UIKit

let DRINK = "drink"

class Profile_Drink: UIViewController {
    
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
    
    func loadStoredFields() {
        // Select the buttons if a user has already done so
        if let drink = localReadKeyValue(key: DRINK) as? String{
            if drink == NODRINK{
                selectDrinkButton(button: noDrinkButton)
                drink_pref = NODRINK
            }
            else if drink == FREQUENT_DRINK{
                selectDrinkButton(button: frequentlyButton)
                drink_pref = FREQUENT_DRINK
            }
            else if drink == SOCIAL_DRINK{
                selectDrinkButton(button: sociallyButton)
                drink_pref = SOCIAL_DRINK
            }
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        polishDrinkButton(button: sociallyButton)
        polishDrinkButton(button: frequentlyButton)
        polishDrinkButton(button: noDrinkButton)
        loadStoredFields()
    }
    
    
    
    @IBAction func noDrinkButtonTapped(_ sender: Any) {
        if drink_pref == NODRINK {
            deselectButton(button: noDrinkButton)
            drink_pref = nil
        } else {
            selectDrinkButton(button: noDrinkButton)
            deselectButtons(buttons: [sociallyButton,frequentlyButton])
            drink_pref = NODRINK
        }
    }
    
    @IBAction func frequentButtonTapped(_ sender: Any) {
        if drink_pref == FREQUENT_DRINK {
            deselectButton(button: frequentlyButton)
            drink_pref = nil
        } else {
            selectDrinkButton(button: frequentlyButton)
            deselectButtons(buttons: [sociallyButton,noDrinkButton])
            drink_pref = FREQUENT_DRINK
        }
    }
    
    @IBAction func sociallyButtonTapped(_ sender: Any) {
        if drink_pref == SOCIAL_DRINK {
            deselectButton(button: sociallyButton)
            drink_pref = nil
        } else {
            selectDrinkButton(button: sociallyButton)
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
    
    func polishDrinkButton(button: UIButton) -> Void {
        button.layer.cornerRadius = 13
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor(red:151/255, green:151/255, blue:151/255, alpha:1).cgColor
        button.layer.masksToBounds = true
    }
    
    func selectDrinkButton(button: UIButton){
        let color = UIColor(red:22/255, green:170/255, blue:184/255, alpha:1)
        button.setTitleColor(.white, for: .normal)
        button.tintColor = UIColor.white
        button.layer.borderColor = color.cgColor
        button.layer.backgroundColor = color.cgColor
    }
    
}
