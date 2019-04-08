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
            LoginUserUtil.fetchLoginUserProfile() {
                user_profile in
                if user_profile != nil {
                    DispatchQueue.main.async {
                        // Wait for user profile to be available
                        let mainPageStoryboard:UIStoryboard = UIStoryboard(name: "MainPage", bundle: nil)
                        let homePage = mainPageStoryboard.instantiateViewController(withIdentifier: "MainTabViewController") as! MainPageTabBarViewController
                        let appDelegate = UIApplication.shared.delegate
                        appDelegate?.window??.rootViewController = homePage
                    }
                    return
                }
            }
        }
        // Take user to login page
        let loginStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginPage = loginStoryboard.instantiateViewController(withIdentifier: "PhoneVerifyViewController") as! PhoneVerifyViewController
        let appDelegate = UIApplication.shared.delegate
        appDelegate?.window??.rootViewController = loginPage
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
