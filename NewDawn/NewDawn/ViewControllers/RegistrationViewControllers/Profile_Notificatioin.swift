//
//  Profile_Notificatioin.swift
//  NewDawn
//
//  Created by macboy on 12/23/18.
//  Copyright © 2018 New Dawn. All rights reserved.
//

import UIKit
import UserNotifications

class Profile_Notificatioin: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        let notif_center = UNUserNotificationCenter.current()
        // Request permission to display alerts and play sounds.
        notif_center.requestAuthorization(options: [.alert, .sound])
        { (granted, error) in
            // Enable or disable features based on authorization.
        }
        // Do any additional setup after loading the view.
    }
}
