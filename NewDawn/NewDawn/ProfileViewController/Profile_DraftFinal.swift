//
//  Profile_DraftFinal.swift
//  NewDawn
//
//  Created by 汤子毅 on 2018/12/26.
//  Copyright © 2018 New Dawn. All rights reserved.
//

import UIKit
import Alamofire

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
        // TODO: Send all info to backend and go to profile page
        let activityIndicator = self.prepareActivityIndicator()
        
        let test_img = UIImage(named: "MeTab")
        let parameters = [
            "caption": "good",
            "order": 1,
            "user": "/api/v1/user/1/",
            ] as [String : Any]
        
        photoUploader(photo: test_img!, filename: "testwow", parameters: parameters, completion: readUploadImage)
        
        let request = createRegistrationRequest()
        
        if request == nil {
            return
        }
        self.removeActivityIndicator(activityIndicator: activityIndicator)
        //self.processSessionTasks(request: request!, callback: readRegistrationResponse)
        
    }
    
    func createRegistrationRequest() -> URLRequest? {
        
        let url = getURL(path: "register/")
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let register_info: [String: Any] = getUserInputInfo()
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: register_info, options: .prettyPrinted)
        } catch let error {
            // TODO: Sepearte error messages into engineer's and user's
            print(error.localizedDescription)
            self.displayMessage(userMessage: "Registration Request Creation Failed", dismiss: false)
            return nil
        }
        return request
    }
    
    func getUserInputInfo() -> [String: Any]{
        
        let user_data = getUserData()
        let account_data = getAccountData()
        let profile_data = getProfileData()
//        let visibility_data = []
        
        let question_answer_data = getQuestionAnswersData()
        
        let pesudo_data = [
            "username":user_data[FIRSTNAME],
            "password":user_data[LASTNAME]
        ]
        
        var register_data = [String: Any]()
        register_data += user_data as! Dictionary<String, String>
        register_data += account_data as! Dictionary<String, String>
        register_data += profile_data
        register_data += question_answer_data
        register_data += pesudo_data as! Dictionary<String, String>
        return register_data
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
        let m_d_y = birthday.components(separatedBy: "/")
        let new_birthday = m_d_y[2] + "-" + m_d_y[0] + "-" + m_d_y[1]
        return new_birthday
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
        
        let imageData = photo.pngData()
        
//        guard let authToken = Locksmith.loadDataForUserAccount(userAccount: "userToken")?["token"] as? String else {
//            return
//        }
        
//        let headers: HTTPHeaders = ["Authorization": authToken]
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
                mpd.append(imageData!, withName: "media", fileName: filename, mimeType: "image/png")
                mpd.append(data, withName: "data")
            }, with: url, encodingCompletion: { (success) in
                debugPrint(success)
            })
        }
    }
    
    // Enhance http request reponse logic
    func readUploadImage(success: Bool) -> Void{
        print(success)
        return
    }
    
}
