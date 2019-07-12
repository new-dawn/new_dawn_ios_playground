//
//  MainPageEndViewController.swift
//  NewDawn
//
//  Created by 汤子毅 on 2019/1/16.
//  Copyright © 2019 New Dawn. All rights reserved.
//

import UIKit

let TEST_MAIN_PAGE_REFRESH_TIME = 5
class MainPageEndViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesBackButton = true
        if TimerUtil.checkIfOutdatedAndRefresh() {
            // Wait for user profile to be available
            let mainPageStoryboard:UIStoryboard = UIStoryboard(name: "MainPage", bundle: nil)
            let homePage = mainPageStoryboard.instantiateViewController(withIdentifier: "MainPageViewController") as! MainPageTabBarViewController
            let appDelegate = UIApplication.shared.delegate
            appDelegate?.window??.rootViewController = homePage
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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
