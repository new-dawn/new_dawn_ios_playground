//
//  ProfileViewController.swift
//  NewDawn
//
//  Created by 汤子毅 on 2018/12/1.
//  Copyright © 2018 New Dawn. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class ProfileViewController: UIViewController {

    @IBOutlet weak var userFullNameLabel: UILabel!
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var hometownLabel: UILabel!
    @IBOutlet weak var jobTitleLabel: UILabel!
    @IBOutlet weak var workAtLabel: UILabel!
    @IBOutlet weak var smokeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Send GET request to get profile information
        // Create Activity Indicator
        let activityIndicator = self.prepareActivityIndicator()
        
        // Send Request
        let request = self.createProfileRequest()
        if request == nil {
            // Request Creation Failed
            return
        }
        
        // Remove activity indicator
        self.removeActivityIndicator(activityIndicator: activityIndicator)
        
        // Process Request & Remove Activity Indicator
        self.processSessionTasks(request: request!, callback: readProfileResponse)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signOutButtonTapped(_ sender: Any) {
        KeychainWrapper.standard.removeObject(forKey: "accessToken")
        KeychainWrapper.standard.removeObject(forKey: "username")
        let signInPage = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        let appDelegate = UIApplication.shared.delegate
        appDelegate?.window??.rootViewController = signInPage
    }
    
    // Create Profile request according to API spec
    func createProfileRequest() -> URLRequest? {
        let username: String? = KeychainWrapper.standard.string(forKey: "userName")
        let accessToken: String? = KeychainWrapper.standard.string(forKey: "accessToken")
        let apiKey = self.getAPIKey(username: username!, accessToken: accessToken!)
        let url = getURL(path: "profile/?user__username=\(String(describing: username!))")
        var request = URLRequest(url:url)
        request.httpMethod = "GET"
        request.addValue("Authorization", forHTTPHeaderField: apiKey)
        return request
    }
    
    // A Callback function to handle login response
    func readProfileResponse(parseJSON: NSDictionary) -> Void {
        let meta = parseJSON["meta"] as? NSDictionary
        if (meta == nil) {
            print("Failed to get Profile")
            return
        }
        // Server returns a list of only one object
        let profile_info_list = parseJSON["objects"] as! NSArray
        let profile_info = profile_info_list[0] as! NSDictionary
        let user = profile_info["user"] as! NSDictionary

        // Display User Full Name
        DispatchQueue.main.async {
            let firstName = user["first_name"] as? String
            let lastName = user["last_name"] as? String
            if (firstName?.isEmpty != true && lastName?.isEmpty != true) {
                self.userFullNameLabel.text = "\(firstName!) \(lastName!)"
            }
            if let school = profile_info["school"] as? String {
                self.schoolLabel.text = school
            }
            if let hometown = profile_info["hometown"] as? String {
                self.hometownLabel.text = hometown
            }
            if let jobTitle = profile_info["job_title"] as? String {
                self.jobTitleLabel.text = jobTitle
            }
            if let employer = profile_info["employer"] as? String {
                self.workAtLabel.text = employer
            }
            if let smoke = profile_info["smoke"] as? String {
                self.smokeLabel.text = smoke
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
