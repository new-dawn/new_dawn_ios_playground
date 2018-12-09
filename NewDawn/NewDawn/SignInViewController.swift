//
//  SignInViewController.swift
//  NewDawn
//
//  Created by 汤子毅 on 2018/12/1.
//  Copyright © 2018 New Dawn. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class SignInViewController: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        print("Sign in button tapped")
        let userName = userNameTextField.text
        let userPassword = userPasswordTextField.text
        
        // Validate Username and Password
        if (userName?.isEmpty)! || (userPassword?.isEmpty)!
        {
            print("Username or Password is Missing")
            self.displayMessage(userMessage: "Username and Password cannot be empty")
            return
        }
        
        // Create Activity Indicator
        let activityIndicator = self.prepareActivityIndicator()
        
        // Send Request
        let request = self.createLoginRequest()
        if request == nil {
            // Request Creation Failed
            return
        }
        
        // Remove activity indicator
        self.removeActivityIndicator(activityIndicator: activityIndicator)
        
        // Process Request & Remove Activity Indicator
        self.processSessionTasks(request: request!, callback: readLoginResponse)
    }

    @IBAction func registerButtonTapped(_ sender: Any) {
        let registerUserViewController =
            self.storyboard?.instantiateViewController(
                withIdentifier: "RegisterUserViewController") as! RegisterUserViewController
        self.present(registerUserViewController, animated: true)
    }
    
    // Create Login request according to API spec
    func createLoginRequest() -> URLRequest? {
        let url = getURL(path: "user/login/")
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let postString = [
            "username": userNameTextField.text!,
            "password": userPasswordTextField.text!
        ] as [String: String]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            self.displayMessage(userMessage: "Login Request Creation Failed", dismiss: false)
            return nil
        }
        return request
    }
    
    // A Callback function to handle login response
    func readLoginResponse(parseJSON: NSDictionary) -> Void {
        let msg = parseJSON["success"] as? Bool
        if msg == false {
            self.displayMessage(userMessage: "Request Failed")
            return
        }
        let userName = parseJSON["username"] as? String
        let accessToken = parseJSON["token"] as? String
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
