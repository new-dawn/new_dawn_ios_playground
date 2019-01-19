//
//  MainPageViewController.swift
//  NewDawn
//
//  Created by 汤子毅 on 2019/1/4.
//  Copyright © 2019 New Dawn. All rights reserved.
//

import UIKit


class MainPageViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var viewModel: MainPageViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getUserData(){ () -> () in
            if ProfileIndexUtil.loadProfileIndex() >= USER_DUMMY_DATA.count {
                // TODO: When the user has seen all profiles, we go back to the first profile.
                // In the future, we should go to an ending page
                self.localStoreKeyValue(key: MAIN_PAGE_PROFILE_INDEX, value: 0)
            }
            print(USER_DUMMY_DATA)
            viewModel = MainPageViewModel(userProfile: UserProfile(data: USER_DUMMY_DATA[ProfileIndexUtil.loadProfileIndex()]))
            tableView.dataSource = viewModel
            tableView.delegate = viewModel
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = UITableView.automaticDimension
            navigationItem.hidesBackButton = true
        }
    }

    @IBAction func skipButtonTapped(_ sender: Any) {
        // The profile is skipped
        if ProfileIndexUtil.reachLastProfile() {
            self.performSegue(withIdentifier: "mainPageEnd", sender: nil)
        } else {
            ProfileIndexUtil.updateProfileIndex()
            self.performSegue(withIdentifier: "mainPageSelf", sender: nil)
        }
    }
    
    func getUserData(handleComplete:(()->())){
        let request = createGetProfileRequest()
        processSessionTasks(request: request!, callback: readReponse)
        handleComplete()
    }
    
    func readReponse(response: NSDictionary) -> Void{
        let profile_responses = response["objects"] as? [[String: Any]]
        for profile in profile_responses!{
            let dummy_user = getProfileInfo(profile: profile)
            USER_DUMMY_DATA.append(dummy_user as NSDictionary)
        }
    }
    
    func encodeParams(raw_params: Dictionary<String, String>) -> String{
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
    
    func createGetProfileRequest() -> URLRequest? {
        // TODO: get username and api_key from keychain/local storage
        let psudo_params = [
            "username":"duckmoll",
            "api_key":"f1c085c2ed2196cb029827c80f879a2ef3ce2189"
        ]
        let params = encodeParams(raw_params: psudo_params)
        let url = getURL(path: "profile/" + params)
        var request = URLRequest(url:url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("ApiKey", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func getProfileInfo(profile: [String: Any]) -> [String: Any]{
        let user_data = profile["user"]! as? [String: Any]
        
        var info = [
            FIRSTNAME: user_data![FIRSTNAME]! as! String,
            LASTNAME: user_data![LASTNAME]! as! String,
            DEGREE: profile[DEGREE]! as! String,
            SCHOOL: profile[SCHOOL]! as! String,
            "images": [
                [
                    "media": "media/images/testcat.JPG",
                    "caption": "First image"
                ],
            ],
            "question_answers":[String]()
            ] as [String : Any]
        for answer_question in (profile["answer_question"] as? [[String: Any]])!{
            let answer_question_dict = [
                "id": answer_question["order"]!,
                QUESTION: answer_question[QUESTION]!,
                ANSWER: answer_question[ANSWER]!
                ] as [String : Any]
            var q_a_temp = info["question_answers"] as? [[String: Any]] ?? [[String: Any]]()
            q_a_temp.append(answer_question_dict)
            info["question_answers"] = q_a_temp
        }
        return info
    }
}
