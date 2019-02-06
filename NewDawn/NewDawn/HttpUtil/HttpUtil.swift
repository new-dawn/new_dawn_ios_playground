//
//  HttpUtil.swift
//  NewDawn
//
//  Created by 汤子毅 on 2019/1/10.
//  Copyright © 2019 New Dawn. All rights reserved.
//

import UIKit
extension UIImageView {
    // A helper function to get URL based on prod/test
    // TODO: Figure out a better way to configure it
    func getURL(path:String, prod:Bool = false) -> URL {
        var final_path = path
        if final_path.hasPrefix("/") == false {
            final_path = "/" + path
        }
        if prod {
            return URL(string: "http://new-dawn.us-west-2.elasticbeanstalk.com" + final_path)!
        } else {
            return URL(string: "http://localhost:8000" + final_path)!
        }
    }
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFill) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
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
        request: URLRequest, callback: @escaping (NSDictionary) -> Void) {
        let task = URLSession.shared.dataTask(with: request) {
            (data: Data?, response: URLResponse?, error: Error?) in
            
            // Check response error
            if error != nil
            {
                print("error=\(String(describing: error!))")
                return
            }
            // Parse Response
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                if let parseJSON = json {
                    callback(parseJSON)
                }
                print("Session Task Processed")
            } catch {
                print("Error processing response")
            }
        }
        task.resume()
    }
    
    static func getURL(path:String, prod:Bool = false) -> URL {
        var final_path = path
        if final_path.hasPrefix("/") == false {
            final_path = "/" + path
        }
        if prod {
            return URL(string: "http://new-dawn.us-west-2.elasticbeanstalk.com/api/v1" + final_path)!
        } else {
            return URL(string: "http://localhost:8000/api/v1" + final_path)!
        }
    }
    
    static func sendAction(user_from: String, user_to: String, action_type: Int, entity_type: Int, entity_id: Int){
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
            "entity_id": entity_id
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
    
    static func readActionResponse(parseJSON: NSDictionary) -> Void {
        let msg = parseJSON["success"] as? Bool
        if msg == false {
            print ("Send Action Data Failed to Send")
            return
        }
    }
    
}
