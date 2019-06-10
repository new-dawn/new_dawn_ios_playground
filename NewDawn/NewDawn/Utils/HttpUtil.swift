//
//  HttpUtil.swift
//  NewDawn
//
//  Created by 汤子毅 on 2019/1/10.
//  Copyright © 2019 New Dawn. All rights reserved.
//

import UIKit
import Kingfisher

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
        self.kf.indicatorType = .activity
        self.kf.setImage(with: url, options: [.transition(.fade(0.2))])
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
