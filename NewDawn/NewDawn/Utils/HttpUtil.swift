//
//  HttpUtil.swift
//  NewDawn
//
//  Created by 汤子毅 on 2019/1/10.
//  Copyright © 2019 New Dawn. All rights reserved.
//

import UIKit
import Kingfisher
import SystemConfiguration

// A image cache storing url -> UIImage pair

let imageCache = NSCache<AnyObject, AnyObject>()

let CONNECT_TO_PROD = true

extension UIImageView {
    // A helper function to get URL based on prod/test
    // TODO: Figure out a better way to configure it
    func getURL(path:String, prod:Bool = CONNECT_TO_PROD) -> URL {
        return HttpUtil.getURL(path: path, prod: prod, isMedia: true)
    }
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFill) {
        self.kf.setImage(with: url, options: [
            .scaleFactor(UIScreen.main.scale),
            .transition(.fade(0.2))
        ])
    }
}

class HttpUtil{
    // A helper function to add parameters to request URL
    static func encodeParams(raw_params: Dictionary<String, String>) -> String{
        var params:String = ""
        var n = 0
        for (key, value) in raw_params{
            if n == 0{
                params = "?" + key + "=" + value
            }else{
                params = params + "&" + key + "=" + value
            }
            n += 1
        }
        return params
    }
    
    static func processSessionTasks(
        request: URLRequest, callback: @escaping (NSDictionary, String?) -> Void) {
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200 || httpURLResponse.statusCode == 201,
                let data = data, error == nil
                else {
                    callback(
                        ["success":false],
                        "Process Session Task Failed: Server return status code without 200/201"
                    )
                    return
                }
            // Parse Response
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary
                if let parseJSON = json {
                    if let response_error = parseJSON["error"] {
                        callback(["success":false], "Process Session Task Failed: Server return error message: \(response_error)")
                        return
                    }
                    callback(parseJSON, nil)
                } else {
                    callback(
                        ["success":false],
                        "Process Session Task Failed: Json cannot be casted into NSDictionary"
                    )
                }
            } catch {
                callback(
                    ["success":false],
                    "Process Session Task Failed: Json parse failed"
                )
            }
        }.resume()
    }
    
    static func getURL(path:String, prod:Bool = CONNECT_TO_PROD, isMedia: Bool = false) -> URL {
        var final_path = path
        if final_path.hasPrefix("/") == false {
            final_path = "/" + path
        }
        if isMedia == true {
            // Media files' path points to an AWS S3 media file server endpoint
            // It wouldn't hit our application server
            return URL(string: path)!
        }
        if prod {
            return URL(string: "http://new-dawn.us-west-2.elasticbeanstalk.com/api/v1" + final_path)!
        } else {
            return URL(string: "http://localhost:8000/api/v1" + final_path)!
        }
    }
    
    static func sendAction(user_from: String, user_to: String, action_type: Int, entity_type: Int, entity_id: Int, message: String){
        let url = getURL(path: "user_action/")
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let action_body: [String: Any] = [
            "user_from": user_from,
            "user_to": user_to,
            "action_type": action_type,
            "entity_type": entity_type,
            "entity_id": entity_id,
            "message": message
            ] as [String : Any]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: action_body, options: .prettyPrinted)
        } catch let error {
            // TODO: Sepearte error messages into engineer's and user's
            print(error.localizedDescription)
            return
        }
        HttpUtil.processSessionTasks(request: request, callback: readActionResponse)
    }
    
    static func readActionResponse(parseJSON: NSDictionary, error: String?) -> Void {
        if error != nil {
            print ("Send Action Data Failed to Send")
            return
        }
        let msg = parseJSON["success"] as? Bool
        if msg == false {
            print ("Send Action Data Failed to Send")
            return
        }
    }
    
    static func getAllMessagesAction(user_from: String, callback: @escaping (NSDictionary, String?) -> Void) {
        // Get a dictionary mapped from matched users to past messages
        let url = getURL(path: "user_action/get_messages/?user_from=\(user_from)")
        var request = URLRequest(url:url)
        request.httpMethod = "GET"
        HttpUtil.processSessionTasks(request: request, callback: callback)
    }
    
    static func sendMessageAction(user_from: String, user_to: String, action_type: Int, entity_type: Int, entity_id: Int, message: String){
        let url = getURL(path: "user_action/send_message/")
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let action_body: [String: Any] = [
            "user_from": user_from,
            "user_to": user_to,
            "action_type": action_type,
            "entity_type": entity_type,
            "entity_id": entity_id,
            "message": message
            ] as [String : Any]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: action_body, options: .prettyPrinted)
        } catch let error {
            // TODO: Sepearte error messages into engineer's and user's
            print(error.localizedDescription)
            return
        }
        self.processSessionTasks(request: request, callback: readActionResponse)
    }
}

class EditProfileUtil{
    
    static func createRegistrationRequest() -> URLRequest? {
        var url = HttpUtil.getURL(path: "register/")
        var httpMethod: String;
        let register_info: [String: Any] = getUserInputInfo()
        let user_id = LoginUserUtil.getLoginUserId()
        if user_id != nil && user_id != 1{
            let user_id_url = String(user_id!) + "/"
            httpMethod = "PUT"
            url = url.appendingPathComponent(user_id_url)
        }else{
            httpMethod = "POST"
        }
        var request = URLRequest(url:url)
        request.httpMethod = httpMethod
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: register_info, options: .prettyPrinted)
        } catch let error {
            // TODO: Sepearte error messages into engineer's and user's
            print(error.localizedDescription)
            return nil
        }
        return request
    }
    
    static func getUserInputInfo() -> [String: Any]{
        let user_data = getUserData()
        let account_data = getAccountData()
        let profile_data = getProfileData()
        let question_answer_data = getQuestionAnswersData()
        
        // TODO: better handle username and password
        let random_id = UUID().uuidString
        let pesudo_data = [
            "username": LocalStorageUtil.localReadKeyValue(key: PHONE_NUMBER) ?? random_id,
            "password":random_id
        ]
        
        var register_data = [String: Any]()
        register_data += user_data as! Dictionary<String, String>
        register_data += account_data as! Dictionary<String, String>
        register_data += profile_data
        register_data += question_answer_data
        register_data += pesudo_data
        return register_data
    }
    
    static func getUserData() -> [String: Any]{
        return  [
            FIRSTNAME: LocalStorageUtil.localReadKeyValue(key: FIRSTNAME) ?? "未知",
            LASTNAME: LocalStorageUtil.localReadKeyValue(key: LASTNAME) ?? "未知",
        ]
    }
    
    static func getAccountData() -> [String: Any] {
        let raw_birthday = LocalStorageUtil.localReadKeyValue(key: BIRTHDAY) ?? "1900/01/01"
        return [
            "birthday":_birthday_str_handler(birthday: raw_birthday as! String),
            "gender":LocalStorageUtil.localReadKeyValue(key: GENDER) ?? "M",
        ]
    }
    
    static func getProfileData() -> [String: Any] {
        let raw_height = LocalStorageUtil.localReadKeyValue(key: HEIGHT) ?? "140"
        return [
            "height": _height_num_handler(height: raw_height as! String),
            "hometown":LocalStorageUtil.localReadKeyValue(key: HOMETOWN) ?? UNKNOWN,
            "school":LocalStorageUtil.localReadKeyValue(key: SCHOOL) ?? UNKNOWN,
            "degree":LocalStorageUtil.localReadKeyValue(key: DEGREE) ?? UNKNOWN,
            "job_title":LocalStorageUtil.localReadKeyValue(key: JOBTITLE) ?? UNKNOWN,
            "employer":LocalStorageUtil.localReadKeyValue(key: WORKPLACE) ?? UNKNOWN,
            "drink":LocalStorageUtil.localReadKeyValue(key: DRINK) ?? UNKNOWN,
            "smoke":LocalStorageUtil.localReadKeyValue(key: SMOKE) ?? UNKNOWN,
            "location":LocalStorageUtil.localReadKeyValue(key: LOCATION) ?? UNKNOWN,
        ]
    }
    
    // Transform mm/dd/yy to yyyy/mm/dd
    static func _birthday_str_handler(birthday: String) -> String{
        return birthday.replacingOccurrences(of: "/", with: "-")
    }
    
    // Transform string to int
    static func _height_num_handler(height: String) -> Int{
        if height.prefix(1) == "<"{
            return 139
        }
        return Int(height.prefix(3))!
    }
    
    // Transform QuestionAnswer struct to array of dicts
    static func _question_answer_handler(existed_question_answers: Array<QuestionAnswer>) -> Array<[String: Any]>{
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
    
    static func getQuestionAnswersData() -> [String: Any] {
        if let existed_question_answers: Array<QuestionAnswer> = LocalStorageUtil.localReadKeyValueStruct(key: QUESTION_ANSWERS) {
            let question_answer_array = _question_answer_handler(existed_question_answers: existed_question_answers)
            return ["answer_question": question_answer_array]
        }
        return ["answer_question": [[String: Any]]()]
    }
    
    
}


public class CheckInternet{
    
    class func Connection() -> Bool{
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
        
        
    }
    
}
