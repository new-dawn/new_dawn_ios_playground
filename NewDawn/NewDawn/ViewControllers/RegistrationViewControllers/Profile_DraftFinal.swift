//
//  Profile_DraftFinal.swift
//  NewDawn
//
//  Created by 汤子毅 on 2018/12/26.
//  Copyright © 2018 New Dawn. All rights reserved.
//

import UIKit
import Alamofire
import CommonCrypto
import PushNotifications
import PusherSwift
import Mixpanel

let pushNotifications = PushNotifications.shared

let UNKNOWN = "未知"

class Profile_DraftFinal: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // Hide navigation bar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func getStartedButtonTapped(_ sender: Any) {
        // TODO: Send all info to backend and go to profile page
        let activityIndicator = self.prepareActivityIndicator()
        
        let request = EditProfileUtil.createRegistrationRequest()
        
        if request == nil {
            return
        }
        
        self.processSessionTasks(request: request!){
            register_response, error  in
            if error != nil{
                self.removeActivityIndicator(activityIndicator: activityIndicator)
                return
            }
            self.removeActivityIndicator(activityIndicator: activityIndicator)
            self.storeCertification(register_response: register_response)
            self.notificationSetUp()
            if let images = ImageUtil.getPersonalImagesWithData(){
                for single_image in images{
                    let single_img = single_image["img"]
                    let single_params = [
                        "order": single_image["order"]!,
                        "caption": single_image["caption"]!,
                        "user": single_image["user_uri"]!
                        ] as [String: Any]
                    let img_name = String.MD5(String(single_image["user_id"] as! Int) + String(single_image["order"] as! Int))! + ".jpeg"
                    ImageUtil.photoUploader(photo: single_img as! UIImage, filename: img_name, parameters: single_params){ success in
                        print("image upload \(success)")}
                }
            }
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "after_register", sender: self)
                Mixpanel.mainInstance().track(event: REGISTRATION_DURATION)
            }
        }
        
    }
    
    func readRegistrationResponse(parseJSON: NSDictionary) -> Void {
        let msg = parseJSON["success"] as? Bool
        if msg == false {
            self.displayMessage(userMessage: "Registration Data Failed to Send")
            return
        }
    }
    
    
    // A helper function to store user id and apikey
    func storeCertification(register_response:NSDictionary) -> Void{
        if let user_id = register_response["id"] as? Int, let token = register_response["token"] as? String {
            _ = LoginUserUtil.saveLoginUserId(user_id: user_id)
            _ = LoginUserUtil.saveAccessToken(token: token)
        }
    }
    
    func notificationSetUp() -> Void{
        // Push notification with instance id and connect to "interest"
        pushNotifications.start(instanceId: "466cb5de-0fd2-40c7-ad45-802b6c79550e")
        pushNotifications.registerForRemoteNotifications()
        try? pushNotifications.addDeviceInterest(interest: "daily_recommendation")
        
        // Authenticate
        
        let tokenProvider = BeamsTokenProvider(authURL: getURL(path: "user/notification/authenticate/").absoluteString) { () -> AuthData in
            let headers: [String: String] = [:] // Headers your auth endpoint needs
            let queryParams: [String: String] = [:] // URL query params your auth endpoint needs
            return AuthData(headers: headers, queryParams: queryParams)
        }
        let user_id = String(LoginUserUtil.getLoginUserId() ?? 1)
        pushNotifications.setUserId(user_id, tokenProvider: tokenProvider, completion: { error in
            guard error == nil else {
                print(error.debugDescription)
                return
            }
            
            print("Successfully authenticated with Pusher Beams")
        })
    }
    
}
