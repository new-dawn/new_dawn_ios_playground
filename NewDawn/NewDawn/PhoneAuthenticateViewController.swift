//
//  PhoneAuthenticateViewController.swift
//  NewDawn
//
//  Created by 汤子毅 on 2018/12/15.
//  Copyright © 2018 New Dawn. All rights reserved.
//

import UIKit

let PHONE_NUMBER = "phone_number"

class PhoneAuthenticateViewController: UIViewController {
    
    
    
    @IBOutlet weak var verificationCodeTextField: UITextField!
    
    // The country code and phone number from previous view
    // are passed from segue
    var userCountryCode = String()
    var userPhoneNumber = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func confirmButtonTapped(_ sender: Any) {
        
        let verificationCode = verificationCodeTextField.text
        
        // Validate Username and Password
        if (verificationCode?.isEmpty)!
        {
            print("Verification Code is Missing")
            self.displayMessage(userMessage: "Verification code cannot be empty")
            return
        }
        
        // Create Activity Indicator
        let activityIndicator = self.prepareActivityIndicator()
        
        // Send Request
        let request = self.createPhoneAuthenticateRequest()
        if request == nil {
            // Request Creation Failed
            return
        }
        
        // Process Request & Remove Activity Indicator
        HttpUtil.processSessionTasks(request: request!) {
            response in
            // Remove activity indicator
            self.removeActivityIndicator(activityIndicator: activityIndicator)
            self.readPhoneAuthenticateResponse(parseJSON: response)
        }
    }
    
    @IBAction func reVerifyButtonTapped(_ sender: Any) {
        // Popup menu for re-verification
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Retype Phone Number", style: .default) { _ in
            self.performSegue(withIdentifier: "reVerify", sender: self.userPhoneNumber)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        present(alert, animated: true)
    }

    // Create Phoen Verify request according to API spec
    func createPhoneAuthenticateRequest() -> URLRequest? {
        let url = getURL(path: "user/phone_verify/authenticate/")
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let postString = [
            "phone_number": userPhoneNumber,
            "country_code": userCountryCode,
            "verification_code": verificationCodeTextField.text!,
        ] as [String: String]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            self.displayMessage(userMessage: "Phone Verify Request Creation Failed", dismiss: false)
            return nil
        }
        return request
    }
    
    // A Callback function to handle phone verify response
    func readPhoneAuthenticateResponse(parseJSON: NSDictionary) -> Void {
        let success = parseJSON["success"] as? Bool
        let message = parseJSON["message"] as? String
        let exist = parseJSON["exist"] as? Bool
        let user_id = parseJSON["user_id"] as? Int
        if success == false {
            self.displayMessage(userMessage: message!)
            return
        }
        
        // Store phone number locally
        LocalStorageUtil.localStoreKeyValue(key: PHONE_NUMBER, value: userPhoneNumber)
        
        if exist != nil && exist == true && user_id != nil {
            _ = LoginUserUtil.saveLoginUserId(user_id: user_id!)
            // Phone verification success. Go to main registration page
            // Go to profile gender/name/birthday fill page
            DispatchQueue.main.async {
                let mainPageStoryboard:UIStoryboard = UIStoryboard(name: "MainPage", bundle: nil)
                let homePage = mainPageStoryboard.instantiateViewController(withIdentifier: "MainTabViewController") as! MainPageTabBarViewController
                let appDelegate = UIApplication.shared.delegate
                appDelegate?.window??.rootViewController = homePage
            }
            return
        }
        
        // Phone verification success. Go to main registration page
        // Go to profile gender/name/birthday fill page
        DispatchQueue.main.async {
            let profileGNBPage = self.storyboard?.instantiateViewController(withIdentifier: "ProfileGNBViewController")
                as! ProfileGNBViewController
            let appDelegate = UIApplication.shared.delegate
            appDelegate?.window??.rootViewController = profileGNBPage
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
