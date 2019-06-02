//
//  AppLandingViewController.swift
//  NewDawn
//
//  Created by 汤子毅 on 2019/3/31.
//  Copyright © 2019 New Dawn. All rights reserved.
//

import UIKit

class AppLandingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Override point for customization after application launch.
        if LoginUserUtil.isLogin() {
            LoginUserUtil.fetchLoginUserProfile(readLocal: false) {
                user_profile, error in
                if error != nil {
                    self.displayMessage(userMessage: "Error: Fetch Login User Profile Failed for user id \(String(describing: LoginUserUtil.getLoginUserId())): \(error!). This can happen if you don't have accessToken stored locally")
                    return
                }
                if user_profile != nil {
                    self.goToMainPage()
                } else if LoginUserUtil.getLoginUserId() == 1 {
                    self.displayMessage(userMessage: "Warning: You are login into an admin account. This account was created automatically thus doesn't have a user profile.")
                    self.goToMainPage()
                } else {
                    self.displayMessage(userMessage: "Warning: You have a login id \(String(describing: LoginUserUtil.getLoginUserId())) stored locally, but it doesn't have a linked user profile. It might because the database has refreshed or your profile has been deleted. For data safety purpose, your local credential will be revoked.")
                    _ = LoginUserUtil.logout()
                }
            }
        }
    }
    
    func goToMainPage() -> Void {
        DispatchQueue.main.async {
            // Wait for user profile to be available
            let mainPageStoryboard:UIStoryboard = UIStoryboard(name: "MainPage", bundle: nil)
            let homePage = mainPageStoryboard.instantiateViewController(withIdentifier: "MainTabViewController") as! MainPageTabBarViewController
            let appDelegate = UIApplication.shared.delegate
            appDelegate?.window??.rootViewController = homePage
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
