//
//  Profile_DrinkSmoke.swift
//  NewDawn
//
//  Created by macboy on 12/23/18.
//  Copyright © 2018 New Dawn. All rights reserved.
//

import UIKit

class Profile_DrinkSmoke: UIViewController {
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
            smoke = true
        }
    }
    
    @IBAction func frequentButtonTapped(_ sender: Any) {
        if frequent == true {
            deselectButton(button: frequentlyButton)
            frequent = false
        } else {
            selectButton(button: frequentlyButton)
            frequent = true
        }
    }
    

}
