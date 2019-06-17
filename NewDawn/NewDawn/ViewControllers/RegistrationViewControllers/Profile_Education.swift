//
//  Profile_Education.swift
//  NewDawn
//
//  Created by macboy on 12/23/18.
//  Copyright © 2018 New Dawn. All rights reserved.
//

import UIKit

let SCHOOL = "school"
let DEGREE = "degree"

class Profile_Education: UIViewController {
    
    var degree = UNKNOWN
    // Constant string keys
    let VISIBLE = "edu_visible"
    
    var visibleField = false


    @IBOutlet weak var undergrad: UIButton!
    @IBOutlet weak var grad: UIButton!
    @IBOutlet weak var phd: UIButton!
    
    
    @IBOutlet weak var schoolTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    // Load fields that user has already filled in
    func loadStoredFields() {
        if let school = localReadKeyValue(key: SCHOOL) as? String {
            schoolTextField.text = school
        }
        if let stored_degree = localReadKeyValue(key: DEGREE) as? String {
            degree = stored_degree
            if degree == "本科" {
                selectDegreeButton(button: undergrad)
            }
            else if degree == "硕士" {
                selectDegreeButton(button: grad)
            }
            else {
                selectDegreeButton(button: phd)
            }
        }
//        if let visible = localReadKeyValue(key: VISIBLE) as? Bool {
//            visibleField = visible
//            // Select the button if a user has already done so
//            if visibleField == true {
//                selectButton(button: visibleButton, text: "Visible")
//            }
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        schoolTextField.setBottomBorder()
        polishDegreeButton(button: undergrad)
        polishDegreeButton(button: grad)
        polishDegreeButton(button: phd)
        continueButton.titleEdgeInsets = UIEdgeInsets(top: -20.0, left: 0.0, bottom: 0.0, right: 0.0)
        backButton.titleEdgeInsets = UIEdgeInsets(top: -20.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        loadStoredFields()
    }
    
    
    @IBAction func undergradTapped(_ sender: Any) {
        selectDegreeButton(button: undergrad)
        deselectButton(button: grad)
        deselectButton(button: phd)
        degree = "本科"
        localStoreKeyValue(key: DEGREE, value: degree)
    }
    
    @IBAction func gradTapped(_ sender: Any) {
        selectDegreeButton(button: grad)
        deselectButton(button: undergrad)
        deselectButton(button: phd)
        degree = "硕士"
        localStoreKeyValue(key: DEGREE, value: degree)
    }
    
    @IBAction func phdTapped(_ sender: Any) {
        selectDegreeButton(button: phd)
        deselectButton(button: undergrad)
        deselectButton(button: grad)
        degree = "博士"
        localStoreKeyValue(key: DEGREE, value: degree)
    }
    
    func polishDegreeButton(button: UIButton) -> Void {
        button.layer.cornerRadius = 13
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor(red:151/255, green:151/255, blue:151/255, alpha:1).cgColor
        button.layer.masksToBounds = true
    }
    
    func selectDegreeButton(button: UIButton) -> Void {
        button.layer.cornerRadius = 13
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor(red:22/255, green:170/255, blue:184/255, alpha:1).cgColor
        button.layer.backgroundColor = UIColor(red:22/255, green:170/255, blue:184/255, alpha:1).cgColor
        button.layer.masksToBounds = true
    }
    
//    @IBAction func visibleButtonTapped(_ sender: Any) {
//        if visibleField == true {
//            deselectButton(button: visibleButton, text: "Invisible")
//            visibleField = false
//            localStoreKeyValue(key: VISIBLE, value: false)
//        } else {
//            selectButton(button: visibleButton, text: "Visible")
//            visibleField = true
//            localStoreKeyValue(key: VISIBLE, value: true)
//        }
//    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        localStoreKeyValue(key: SCHOOL, value: schoolTextField.text!)
    }

    
    

}
