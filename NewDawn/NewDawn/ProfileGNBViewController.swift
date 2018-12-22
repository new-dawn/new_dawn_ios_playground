//
//  ProfileGNBViewController.swift
//  NewDawn
//
//  Created by 汤子毅 on 2018/12/21.
//  Copyright © 2018 New Dawn. All rights reserved.
//

import UIKit

class ProfileGNBViewController: UIViewController {

    @IBOutlet weak var womenTextField: UITextField!
    @IBOutlet weak var menTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        polishTextField(textField: womenTextField)
        polishTextField(textField: menTextField)
        polishTextField(textField: nameTextField)
        polishTextField(textField: birthdayTextField)
        // Do any additional setup after loading the view.
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
