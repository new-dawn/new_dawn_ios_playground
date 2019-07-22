//
//  PhoneAuthenticateViewController.swift
//  NewDawn
//
//  Created by 汤子毅 on 2018/12/15.
//  Copyright © 2018 New Dawn. All rights reserved.
//

import UIKit
import TaskQueue

let PHONE_NUMBER = "phone_number"

class PhoneAuthenticateViewController: UIViewController {
    
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBOutlet weak var verificationCodeTextField1: VerificationTextField!
    @IBOutlet weak var verificationCodeTextField2: VerificationTextField!
    @IBOutlet weak var verificationCodeTextField3: VerificationTextField!
    @IBOutlet weak var verificationCodeTextField4: VerificationTextField!
    
    
    // The country code and phone number from previous view
    // are passed from segue
    var userCountryCode = String()
    var userPhoneNumber = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmButton.titleEdgeInsets = UIEdgeInsets(top: -20.0, left: 0.0, bottom: 0.0, right: 0.0)
        // Do any additional setup after loading the view.
    }

    @IBAction func confirmButtonTapped(_ sender: Any) {
        self.confirmButton.isEnabled = false
        let verificationCode = verificationCodeTextField1.text! + verificationCodeTextField2.text! + verificationCodeTextField3.text! + verificationCodeTextField4.text!
        
        // Validate Username and Password
        if (verificationCode.isEmpty)
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
        self.processSessionTasks(request: request!) {
            response,error  in
            // Remove activity indicator
            self.removeActivityIndicator(activityIndicator: activityIndicator)
            if error != nil{
                print("READ PHONE RESPONSE ERROR")
                self.confirmButton.isEnabled = true
            }else{
                self.readPhoneAuthenticateResponse(parseJSON: response)
            }
        }
    }
    
    @IBAction func reVerifyButtonTapped(_ sender: Any) {
        // Popup menu for re-verification
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "其他手机号码", style: .default) { _ in
            self.performSegue(withIdentifier: "reVerify", sender: self.userPhoneNumber)
        })
        alert.addAction(UIAlertAction(title: "再寄出一组验证码", style: .default) { _ in
            // Create Activity Indicator
            let activityIndicator = self.prepareActivityIndicator()
            
            // Send Request
            let request = self.createPhoneVerifyRequest()
            if request == nil {
                // Request Creation Failed
                return
            }
            
            // Process Request
            self.processSessionTasks(request: request!) {
                response,error  in
                // Remove activity indicator
                self.removeActivityIndicator(activityIndicator: activityIndicator)
                self.readPhoneVerifyResponse(parseJSON: response)
            }
        })
        alert.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil))
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
            "verification_code": verificationCodeTextField1.text! + verificationCodeTextField2.text! + verificationCodeTextField3.text! + verificationCodeTextField4.text!,
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
            self.displayMessage(userMessage: message ?? "READ PHONE ERROR")
            return
        }
        
        // Store phone number locally
        LocalStorageUtil.localStoreKeyValue(key: PHONE_NUMBER, value: userPhoneNumber)
        
        if exist != nil && exist == true && user_id != nil {
            let
            _ = LoginUserUtil.saveLoginUserId(user_id: user_id!)
            // TODO: Let server return access token after login and store them in local storage
            _ = LoginUserUtil.saveAccessToken(token: "N/A")
            // Phone verification success. Go to main registration page
            // Go to profile gender/name/birthday fill page
            LoginUserUtil.fetchUserProfile(user_id: user_id!, accessToken: "N/A") {
                user_profile, error in
                if error != nil {
                    self.displayMessage(userMessage: "Error: Fetch Login User Profile Failed for user id \(String(describing: LoginUserUtil.getLoginUserId())): \(error!). This can happen if you don't have accessToken stored locally")
                    self.confirmButton.isEnabled = true
                    return
                }
                if user_profile != nil {
                    let queue = TaskQueue()
                    queue.tasks +=~ {
                        LoginUserUtil.downloadOverwriteLocalInfo(profile: user_profile!)
                    }
                    queue.tasks +=~ {
                        LoginUserUtil.downloadOverwriteLocalImages(profile: user_profile!)
                    }
                    queue.tasks +=! {
                        let mainPageStoryboard:UIStoryboard = UIStoryboard(name: "MainPage", bundle: nil)
                        let homePage = mainPageStoryboard.instantiateViewController(withIdentifier: "MainTabViewController") as! MainPageTabBarViewController
                        let appDelegate = UIApplication.shared.delegate
                        appDelegate?.window??.rootViewController = homePage
                    }
                    queue.run()
                } else if LoginUserUtil.getLoginUserId() == 1 {
                    self.displayMessage(userMessage: "Warning: You are login into an admin account. This account was created automatically thus doesn't have a user profile.")
                } else {
                    self.displayMessage(userMessage: "Warning: You have a login id \(String(describing: LoginUserUtil.getLoginUserId())) stored locally, but it doesn't have a linked user profile. It might because the database has refreshed or your profile has been deleted. For data safety purpose, your local credential will be revoked.")
                    _ = LoginUserUtil.logout()
                }
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
    
    // Create Phoen Verify request according to API spec
    func createPhoneVerifyRequest() -> URLRequest? {
        let url = HttpUtil.getURL(path: "user/phone_verify/request/")
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let postString = [
            "phone_number": userPhoneNumber,
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
