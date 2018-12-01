//
//  RegisterUserViewController.swift
//  NewDawn
//
//  Created by 汤子毅 on 2018/12/1.
//  Copyright © 2018 New Dawn. All rights reserved.
//

import UIKit

class RegisterUserViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func signUpButtonTapped(_ sender: Any) {
        // Validate required fields are not empty
        if (firstNameTextField.text?.isEmpty)! ||
            (lastNameTextField.text?.isEmpty)! ||
            (emailTextField.text?.isEmpty)! ||
            (passwordTextField.text?.isEmpty)!
        {
            displayMessage(userMessage: "Missing Fields")
            return
        }
        
        // Validate password
        if passwordTextField.text == repeatPasswordTextField.text
        {
            displayMessage(userMessage: "Password Doesn't Match")

            return
        }
    }
    
    func displayMessage(userMessage:String) -> Void {
        DispatchQueue.main.async {
            let alertController = UIAlertController(
                title: "Alert", message: userMessage, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default)
            {
                (action:UIAlertAction!) in
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
