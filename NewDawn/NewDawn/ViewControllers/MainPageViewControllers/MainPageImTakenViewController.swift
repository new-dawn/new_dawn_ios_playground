//
//  MainPageImTakenViewController.swift
//  NewDawn
//
//  Created by 汤子毅 on 2019/7/1.
//  Copyright © 2019 New Dawn. All rights reserved.
//

import UIKit

class MainPageImTakenViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LoginUserUtil.fetchLoginUserProfile(readLocal: false) {
            user_profile, _ in
            if user_profile?.takenBy == -1 {
                self.goToMainPage()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        // Do any additional setup after loading the view.
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
