//
//  PreferenceSonViewControler.swift
//  NewDawn
//
//  Created by Junlin Liu on 4/17/19.
//  Copyright © 2019 New Dawn. All rights reserved.
//

import Foundation
import UIKit

class GenderPrefViewController: UIViewController{
    
    
    @IBOutlet weak var womanButton: UIButton!
    @IBOutlet weak var manButton: UIButton!
    override func viewDidLoad() {
        polishUIButton(button: womanButton)
        polishUIButton(button: manButton)
    }
    var gender_pref: String = UNKNOWN
    
    
    @IBAction func womanButtonTapped(_ sender: Any) {
        if gender_pref == UNKNOWN || gender_pref == "man"{
            selectButton(button: womanButton)
            deselectButton(button: manButton)
            gender_pref = "woman"
        } else{
            deselectButton(button: womanButton)
            gender_pref = UNKNOWN
        }
    }
    
    @IBAction func manButtonTapped(_ sender: Any) {
        if gender_pref == UNKNOWN || gender_pref == "woman"{
            selectButton(button: manButton)
            deselectButton(button: womanButton)
            gender_pref = "man"
        } else{
            deselectButton(button: manButton)
            gender_pref = UNKNOWN
        }
    }
}
