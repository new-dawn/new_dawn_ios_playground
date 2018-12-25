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
    var smoke = false
    var socially = false
    var frequent = false
    
    @IBOutlet weak var sociallyButton: UIButton!
    @IBOutlet weak var frequentlyButton: UIButton!
    @IBOutlet weak var noSmokeButton: UIButton!
    @IBOutlet weak var visibleButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        polishUIButton(button: sociallyButton)
        polishUIButton(button: frequentlyButton)
        polishUIButton(button: noSmokeButton)
        polishUIButton(button: visibleButton)
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
        if smoke == true {
            deselectButton(button: noSmokeButton)
            smoke = false
        } else {
            selectButton(button: noSmokeButton)
            deselectButtons(buttons: [sociallyButton,frequentlyButton])
            smoke = true
            socially = false
            frequent = false
        }
    }
    
    @IBAction func frequentButtonTapped(_ sender: Any) {
        if frequent == true {
            deselectButton(button: frequentlyButton)
            frequent = false
        } else {
            selectButton(button: frequentlyButton)
            deselectButtons(buttons: [sociallyButton,noSmokeButton])
            smoke = false
            socially = false
            frequent = true
        }
    }
    
    @IBAction func sociallyButtonTapped(_ sender: Any) {
        if socially == true {
            deselectButton(button: sociallyButton)
            socially = false
        } else {
            selectButton(button: sociallyButton)
            deselectButtons(buttons: [frequentlyButton,noSmokeButton])
            smoke = false
            socially = true
            frequent = false
        }
    }
    
}
