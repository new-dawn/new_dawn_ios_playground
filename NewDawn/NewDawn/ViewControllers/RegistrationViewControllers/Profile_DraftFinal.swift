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

let pushNotifications = PushNotifications.shared

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
    
    
    @IBAction func getStartedButtonTapped(_ sender: Any) {
        let activityIndicator = self.prepareActivityIndicator()
    
        LoginUserUtil.fetchLoginUserProfile(true) {
            user_profile, error in
            var request: URLRequest? = nil
            if let user_id = user_profile?.user_id, let user_uri = user_profile?.user_uri {
                print("Warning: User profile with id \(user_id) and uri \(user_uri) already exist. This might imply that the registration page is being used as an editting page.")
                let user_uri_arr = user_uri.components(separatedBy: "/")
                // The user uri is of the form /api/v1/user/5/
                let user_raw_id = user_uri_arr.dropLast().last
                request = self.createRegistrationRequest(
                    true, user_raw_id: user_raw_id)
            } else {
                request = self.createRegistrationRequest(
                    false)
            }
            if request == nil {
                self.displayMessage(userMessage: "Error: User request fails to construct")
            }
            HttpUtil.processSessionTasks(request: request!){
                register_response, error in
                self.removeActivityIndicator(activityIndicator: activityIndicator)
                if error != nil {
                    self.displayMessage(userMessage: "Error: Registration request sent failed: \(error!)")
                    return
                }
                self.storeCertification(register_response: register_response)
                self.notificationSetUp()
                ImageUtil.getPersonalImagesWithData() {
                    images, error in
                    if error != nil {
                        self.displayMessage(userMessage: "Error: Getting personal images failed during registration: \(error!)")
                        return
                    }
                    if images == nil {
                        self.displayMessage(userMessage: "Warning: Getting personal images returns nil during registration: \(error!)")
                        return
                    }
                    for single_image in images! {
                        let single_img = single_image["img"]
                        let single_params = [
                            "order": single_image["order"]!,
                            "caption": single_image["caption"]!,
                            "user": single_image["user_uri"]!
                            ] as [String: Any]
                        let img_name = self.MD5(String(single_image["user_id"] as! String) + String(single_image["order"] as! Int))! + ".jpeg"
                        self.photoUploader(photo: single_img as! UIImage, filename: img_name, parameters: single_params){ success in
                            print("image upload \(success)")}
                    }
                }
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "after_register", sender: self)
                }
            }
        }
    }
    
    func createRegistrationRequest(_ user_exist: Bool, user_raw_id: String? = nil) -> URLRequest? {
        var url = getURL(path: "register/")
        var httpMethod: String;
        var request: URLRequest
        if let register_info = getUserInputInfo() {
            if user_exist && user_raw_id != nil {
                httpMethod = "PUT"
                url.appendPathComponent(user_raw_id! + "/")
            } else {
                httpMethod = "POST"
            }
            request = URLRequest(url:url)
            request.httpMethod = httpMethod
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: register_info, options: .prettyPrinted)
            } catch let error {
                // TODO: Sepearte error messages into engineer's and user's
                print(error.localizedDescription)
                self.displayMessage(userMessage: "Registration Request Creation Failed: Json serialization failed", dismiss: false)
                return nil
            }
        } else {
            self.displayMessage(userMessage: "Registration Request Creation Failed: Incomplete registration info", dismiss: false)
            return nil
        }
        return request
    }
    
    func getUserInputInfo() -> [String: Any]? {
        
        let user_data = getUserData()
        let account_data = getAccountData()
        let profile_data = getProfileData()
        let question_answer_data = getQuestionAnswersData()
        
        // TODO: better handle username and password
        if let phone_number = LocalStorageUtil.localReadKeyValue(key: PHONE_NUMBER) {
            let random_id = UUID().uuidString
            let pesudo_data = [
                "username":phone_number,
                "password":random_id
            ]
            var register_data = [String: Any]()
            register_data += user_data as! Dictionary<String, String>
            register_data += account_data as! Dictionary<String, String>
            register_data += profile_data
            register_data += question_answer_data
            register_data += pesudo_data
            return register_data
        } else {
            self.displayMessage(userMessage: "Error: Phone number doesn't exist in local storage, thus cannot construct username for registration")
            return nil
        }
    }
    
    func readRegistrationResponse(parseJSON: NSDictionary) -> Void {
        let msg = parseJSON["success"] as? Bool
        if msg == false {
            self.displayMessage(userMessage: "Registration Data Failed to Send")
            return
        }
    }
    
    func getUserData() -> [String: Any]{
        return  [
            FIRSTNAME: localReadKeyValue(key: FIRSTNAME)!,
            LASTNAME: localReadKeyValue(key: LASTNAME)!,
        ]
    }
    
    func getAccountData() -> [String: Any] {
        return [
            "birthday":_birthday_str_handler(birthday: localReadKeyValue(key: BIRTHDAY) as! String),
            "gender":localReadKeyValue(key: GENDER)!,
        ]
    }
    
    func getProfileData() -> [String: Any] {
        return [
            "height": _height_num_handler(height: localReadKeyValue(key: HEIGHT) as! String),
            "hometown":localReadKeyValue(key: HOMETOWN) ?? UNKNOWN,
            "school":localReadKeyValue(key: SCHOOL) ?? UNKNOWN,
            "degree":localReadKeyValue(key: DEGREE) ?? UNKNOWN,
            "job_title":localReadKeyValue(key: JOBTITLE) ?? UNKNOWN,
            "employer":localReadKeyValue(key: WORKPLACE) ?? UNKNOWN,
            "drink":localReadKeyValue(key: DRINK) ?? UNKNOWN,
            "smoke":localReadKeyValue(key: SMOKE) ?? UNKNOWN,
        ]
    }
    
    
    // Transform mm/dd/yy to yyyy/mm/dd
    func _birthday_str_handler(birthday: String) -> String{
        return birthday.replacingOccurrences(of: "/", with: "-")
    }
    
    // Transform string to int
    func _height_num_handler(height: String) -> Int{
        if height.prefix(1) == "<"{
            return 139
        }
        return Int(height.prefix(3))!
    }
    
    // Transform QuestionAnswer struct to array of dicts
    func _question_answer_handler(existed_question_answers: Array<QuestionAnswer>) -> Array<[String: Any]>{
        var question_answer_array = [[String: Any]]()
        var num_count = 1;
        for question_answer in existed_question_answers{
            let holder = [
                "question": question_answer.question.question,
                "answer": question_answer.answer,
                "order": num_count
                ] as [String : Any]
            num_count += 1
            question_answer_array.append(holder)
        }
        return question_answer_array
    }
    
    func getQuestionAnswersData() -> [String: Any] {
        if let existed_question_answers: Array<QuestionAnswer> = localReadKeyValueStruct(key: QUESTION_ANSWERS) {
            let question_answer_array = _question_answer_handler(existed_question_answers: existed_question_answers)
            return ["answer_question": question_answer_array]
        }
        return ["answer_question": [[String: Any]]()]
    }
    
    // A helper function to upload image
    func photoUploader(photo: UIImage, filename: String, parameters: [String: Any], completion: @escaping (Bool) -> Void) {
        
        let imageData = photo.jpegData(compressionQuality: 1)
        
//        guard let authToken = Locksmith.loadDataForUserAccount(userAccount: "userToken")?["token"] as? String else {
//            return
//        }
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        var url: URLRequest?
        
        let image_upload_url = getURL(path: "image/")
        
        do {
            url = try URLRequest(url: image_upload_url, method: .post, headers: headers)
        } catch {
            print("Error")
        }

        let data = try! JSONSerialization.data(withJSONObject: parameters)

        
        if let url = url {
            upload(multipartFormData: { (mpd) in
                mpd.append(imageData!, withName: "media", fileName: filename, mimeType: "image/jpeg")
                mpd.append(data, withName: "data")
            }, with: url, encodingCompletion: { (success) in
                debugPrint(success)
            })
        }
    }
    
    
    // A helper function to store user id and apikey
    func storeCertification(register_response:NSDictionary) -> Void{
        if let user_id = register_response["id"] as? String, let token = register_response["token"] as? String {
            _ = LoginUserUtil.saveLoginUserId(user_id: user_id)
            _ = LoginUserUtil.saveAccessToken(token: token)
        }
    }
    
    func MD5(_ string: String) -> String? {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        var digest = [UInt8](repeating: 0, count: length)
        
        if let d = string.data(using: String.Encoding.utf8) {
            _ = d.withUnsafeBytes { (body: UnsafePointer<UInt8>) in
                CC_MD5(body, CC_LONG(d.count), &digest)
            }
        }
        
        return (0..<length).reduce("") {
            $0 + String(format: "%02x", digest[$1])
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
        let user_id = String(LoginUserUtil.getLoginUserId() ?? UNKNOWN)
        pushNotifications.setUserId(user_id, tokenProvider: tokenProvider, completion: { error in
            guard error == nil else {
                print(error.debugDescription)
                return
            }
            print("Successfully authenticated with Pusher Beams")
        })
    }
    
}
