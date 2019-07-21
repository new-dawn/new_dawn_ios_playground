//
//  MainPageEndViewController.swift
//  NewDawn
//
//  Created by 汤子毅 on 2019/1/16.
//  Copyright © 2019 New Dawn. All rights reserved.
//

import UIKit

class MainPageEndViewController: UIViewController {
    
    @IBOutlet weak var timer: UILabel!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesBackButton = true
        self.tabBarController?.tabBar.items?.first?.badgeValue = nil
        let nextDate = TimerUtil.readRefreshDate()
        timer.text = "\(nextDate.month)/\(nextDate.day) \(nextDate.hour):\(nextDate.minute):\(nextDate.second)"
        if TimerUtil.checkIfOutdatedAndRefresh() {
            // Refresh user profile
            LocalStorageUtil.localRemoveKey(key: CANDIDATE_PROFILES)
            let mainPageStoryboard:UIStoryboard = UIStoryboard(name: "MainPage", bundle: nil)
            let homePage = mainPageStoryboard.instantiateViewController(withIdentifier: "MainTabViewController") as! MainPageTabBarViewController
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
