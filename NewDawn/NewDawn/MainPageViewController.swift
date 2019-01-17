//
//  MainPageViewController.swift
//  NewDawn
//
//  Created by 汤子毅 on 2019/1/4.
//  Copyright © 2019 New Dawn. All rights reserved.
//

import UIKit

let MAIN_PAGE_PROFILE_INDEX = "main_page_profile_index"

class MainPageViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var viewModel: MainPageViewModel!
    
    func loadProfileIndex() -> Int {
        if let index = self.localReadKeyValue(key: MAIN_PAGE_PROFILE_INDEX) as? Int {
            return index
        }
        self.localStoreKeyValue(key: MAIN_PAGE_PROFILE_INDEX, value: 0)
        return 0
    }

    func updateProfileIndex() -> Void {
        self.localStoreKeyValue(key: MAIN_PAGE_PROFILE_INDEX, value: loadProfileIndex() + 1)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        getUserData()
        if loadProfileIndex() >= USER_DUMMY_DATA.count {
            // TODO: When the user has seen all profiles, we go back to the first profile.
            // In the future, we should go to an ending page
            self.localStoreKeyValue(key: MAIN_PAGE_PROFILE_INDEX, value: 0)
        }
        viewModel = MainPageViewModel(userProfile: UserProfile(data: USER_DUMMY_DATA[loadProfileIndex()]))
        tableView.dataSource = viewModel
        tableView.delegate = viewModel
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        navigationItem.hidesBackButton = true
    }

    @IBAction func skipButtonTapped(_ sender: Any) {
        updateProfileIndex()
    }
    
    func getUserData(){
        let request = createGetProfileRequest()
        processSessionTasks(request: request!, callback: readReponse)
    }
    
    func parseUserData(json: NSDictionary){

    }
    
    func readReponse(parseJSON: NSDictionary) -> Void{
        print(parseJSON)
        let msg = parseJSON["success"] as? Bool
        if msg == false {
            print("Registration Data Failed to Send")
            return
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
    
    struct User:Decodable{
        let date_joined: String
        let email: String
        let first_name: String
        let is_active: Int
        let id: Int
        let is_superuser: Int
        let last_login: String
        let last_name: String
        let resource_uri: String
        let username: String
    }
    
    struct UserProfileStruct: Decodable {
        let birthday: String
        let city_preference: String
        let creation_date: String
        let gender: String
        let id: Int
        let name: String
        let phone_number: String
        let resource_uri: String
        let user: [User]
    }
    
    struct backendGetResponse: Decodable {
        let meta: String
        let objectts: [UserProfileStruct]
    }
    
}
