//
//  RegisterUserViewController.swift
//  NewDawn
//
//  Created by 汤子毅 on 2018/12/1.
//  Copyright © 2018 New Dawn. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
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
            self.displayMessage(userMessage: "Missing Fields", dismiss: false)
            return
        }
        
        // Validate password
        if passwordTextField.text != repeatPasswordTextField.text
        {
            self.displayMessage(userMessage: "Password Doesn't Match", dismiss: false)
            return
        }
        
        // Activity Indicator Created
        let activityIndicator = self.prepareActivityIndicator()
        
        // Create Request
        let request = self.createRegisterRequest()
        if request == nil {
            // Request Creation Failed
            return
        }
        
        // Remove activity indicator
        self.removeActivityIndicator(activityIndicator: activityIndicator)
        
        // Process Request & Rmove Activity Indicator
//        self.processSessionTasks(request: request!, callback: readRegisterResponse)

    }
    
    func createRegisterRequest() -> URLRequest? {
        let url = self.getURL(path: "register/")
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let postString = [
            "first_name": firstNameTextField.text!,
            "last_name": lastNameTextField.text!,
            "email": emailTextField.text!,
            "password": passwordTextField.text!,
            "username": emailTextField.text!
        ] as [String: String]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            self.displayMessage(userMessage: "Register Request Creation Failed", dismiss: false)
            return nil
        }
        return request
    }
    
    func readRegisterResponse(parseJSON: NSDictionary) -> Void {
        let userName = parseJSON["username"] as? String
        let accessToken = parseJSON["token"] as? String
        if userName?.isEmpty == true || accessToken?.isEmpty == true {
            print("Cannot receive username and access token")
        }
        // This access token is required with requests to get sensitive/private data
        print("Username: \(String(describing: userName))")
        print("Access token: \(String(describing: accessToken))")
        let saveUserName: Bool = KeychainWrapper.standard.set(userName!, forKey: "userName")
        let saveAccessToken: Bool = KeychainWrapper.standard.set(accessToken!, forKey: "accessToken")
        print("Username Saved to Keychain: \(saveUserName)")
        print("Access token Saved to Keychain: \(saveAccessToken)")
        if (userName?.isEmpty)!
        {
            self.displayMessage(userMessage: "No Username Found")
            return
        }
        if (accessToken?.isEmpty)!
        {
            self.displayMessage(userMessage: "No Access Token Found")
            return
        }
        // Go to profile page
        DispatchQueue.main.async {
            let profilePage = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController")
                as! ProfileViewController
            //
            let appDelegate = UIApplication.shared.delegate
            appDelegate?.window??.rootViewController = profilePage
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
