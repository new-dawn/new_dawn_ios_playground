//
//  Profile_Education.swift
//  NewDawn
//
//  Created by macboy on 12/23/18.
//  Copyright © 2018 New Dawn. All rights reserved.
//

import UIKit

class Profile_Education: UIViewController {
    
    var visible = false
    @IBOutlet weak var degreeTextField: UITextField!
    @IBOutlet weak var schoolTextField: UITextField!
    @IBOutlet weak var visibleButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        polishTextField(textField: schoolTextField)
        polishTextField(textField: degreeTextField)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
