//
//  PhoneVerifyViewController.swift
//  NewDawn
//
//  Created by 汤子毅 on 2018/12/15.
//  Copyright © 2018 New Dawn. All rights reserved.
//

import UIKit

class PhoneVerifyViewController: UIViewController {

    @IBOutlet weak var phoneNumberTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        polishTextField(textField: phoneNumberTextField)
        phoneNumberTextField.setLeftPaddingPoints(25)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        // For US only
        let phoneNumber = phoneNumberTextField.text
        
        // Validate Username and Password
        if (phoneNumber?.isEmpty)!
        {
            print("Country Code or Phone Number is Missing")
            return
        }
        
        if (phoneNumber == "11") {
            // WARNING: This is for testing only
            // When phone number field is set to this secret word
            // viewer will automatically login as a super user
            // Notice that super user doesn't have a profile
            DispatchQueue.main.async {
                _ = LoginUserUtil.saveLoginUserId(user_id: 1)
                let mainPageStoryboard:UIStoryboard = UIStoryboard(name: "MainPage", bundle: nil)
                let homePage = mainPageStoryboard.instantiateViewController(withIdentifier: "MainTabViewController") as! MainPageTabBarViewController
                let appDelegate = UIApplication.shared.delegate
                appDelegate?.window??.rootViewController = homePage
            }
            return
        }
        
        // Create Activity Indicator
        let activityIndicator = self.prepareActivityIndicator()
        
        // Send Request
        let request = self.createPhoneVerifyRequest()
        if request == nil {
            // Request Creation Failed
            return
        }
        
        // Process Request
        HttpUtil.processSessionTasks(request: request!) {
            response in
            // Remove activity indicator
            self.removeActivityIndicator(activityIndicator: activityIndicator)
            self.readPhoneVerifyResponse(parseJSON: response)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Prepare fields sent to next page
        let authenticateController = segue.destination as! PhoneAuthenticateViewController
        authenticateController.userPhoneNumber = phoneNumberTextField.text!
        authenticateController.userCountryCode = "1"
    }
    
    // Create Phoen Verify request according to API spec
    func createPhoneVerifyRequest() -> URLRequest? {
        let url = HttpUtil.getURL(path: "user/phone_verify/request/")
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let postString = [
            "phone_number": phoneNumberTextField.text!,
            "country_code": "1"
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
    func readPhoneVerifyResponse(parseJSON: NSDictionary) -> Void {
        let msg = parseJSON["success"] as? Bool
        if msg == false {
            self.displayMessage(userMessage: "Phone Number Verification Failed to Send")
            return
        }
        DispatchQueue.main.async {
            // Pass country code and phone number to next view
            self.performSegue(withIdentifier: "phoneVerify", sender: self)
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
