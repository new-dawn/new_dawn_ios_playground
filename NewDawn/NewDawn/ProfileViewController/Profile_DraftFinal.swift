//
//  Profile_DraftFinal.swift
//  NewDawn
//
//  Created by 汤子毅 on 2018/12/26.
//  Copyright © 2018 New Dawn. All rights reserved.
//

import Foundation
import UIKit

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
        
        let request = createRegistrationRequest()
        
        if request == nil {
            return
        }
        self.removeActivityIndicator(activityIndicator: activityIndicator)
        self.processSessionTasks(request: request!, callback: readRegistrationResponse)
        
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
        
        let user_data = [
            "first_name":localReadKeyValue(key: "firstname")!,
            "last_name":localReadKeyValue(key: "lastname")!,
        ]
        let account_data = [
            "birthday":_birthday_str_handler(birthday: localReadKeyValue(key: "birthday") as! String),
            "gender":localReadKeyValue(key: "gender")!,
        ]
        let profile_data = [
            "height": _height_num_handler(height: localReadKeyValue(key: "height")! as! String),
            "hometown":localReadKeyValue(key: "hometown")!,
            "school":localReadKeyValue(key: "school")!,
            "degree":localReadKeyValue(key: "degree")!,
            "job_title":localReadKeyValue(key: "job_title")!,
            "employer":localReadKeyValue(key: "employer")!,
            "drink":localReadKeyValue(key: "drink")!,
            "smoke":localReadKeyValue(key: "smoke")!,
        ]
//        let visibility_data = [
//        "height_visible":localReadKeyValue(key: "height_visible")!,
//        "hometown_visible":localReadKeyValue(key: "hometown_visible")!,
//        "edu_visible":localReadKeyValue(key: "edu_visible")!,
//        "work_visible":localReadKeyValue(key: "work_visible")!,
//        "smoke_visible":localReadKeyValue(key: "smoke_visible")!,
//        "drink_visible":localReadKeyValue(key: "drink_visible")!,
//        ]
        
        let question_answer_data = ["answer_question": getQuestionAnswersFromLocalStore()]
        
        let pesudo_info = [
            "username":user_data["first_name"],
            "password":user_data["first_name"]
        ]
        
        var register_data = [String: Any]()
        register_data += user_data as! Dictionary<String, String>
        register_data += account_data as! Dictionary<String, String>
        register_data += profile_data
        register_data += question_answer_data
        register_data += pesudo_info as! Dictionary<String, String>
        return register_data
    }
    
    func readRegistrationResponse(parseJSON: NSDictionary) -> Void {
        let msg = parseJSON["success"] as? Bool
        if msg == false {
            self.displayMessage(userMessage: "Registration Data Failed to Send")
            return
        }
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
    
    func getQuestionAnswersFromLocalStore() -> Array<[String: Any]> {
        if let existed_question_answers: Array<QuestionAnswer> = localReadKeyValueStruct(key: QUESTION_ANSWERS) {
            let question_answer_array = _question_answer_handler(existed_question_answers: existed_question_answers)
            return question_answer_array
        }
        return [[String: Any]]()
    }
}
