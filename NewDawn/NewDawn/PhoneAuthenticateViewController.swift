//
//  PhoneAuthenticateViewController.swift
//  NewDawn
//
//  Created by 汤子毅 on 2018/12/15.
//  Copyright © 2018 New Dawn. All rights reserved.
//

import UIKit

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
        let profileGNBPage = self.storyboard?.instantiateViewController(withIdentifier: "ProfileGNBViewController")
            as! ProfileGNBViewController
        let appDelegate = UIApplication.shared.delegate
        appDelegate?.window??.rootViewController = profileGNBPage
        
//        
//        let verificationCode = verificationCodeTextField.text
//        
//        // Validate Username and Password
//        if (verificationCode?.isEmpty)!
//        {
//            print("Verification Code is Missing")
//            self.displayMessage(userMessage: "Verification code cannot be empty")
//            return
//        }
//        
//        // Create Activity Indicator
//        let activityIndicator = self.prepareActivityIndicator()
//        
//        // Send Request
//        let request = self.createPhoneAuthenticateRequest()
//        if request == nil {
//            // Request Creation Failed
//            return
//        }
//        
//        // Remove activity indicator
//        self.removeActivityIndicator(activityIndicator: activityIndicator)
//        
//        // Process Request & Remove Activity Indicator
//        self.processSessionTasks(request: request!, callback: readPhoneAuthenticateResponse)
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
        if success == false {
            self.displayMessage(userMessage: message!)
            return
        }
        
        // Store phone number locally
        localStoreKeyValue(key: "phoneNumber", value: userPhoneNumber)
        
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
