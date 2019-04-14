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
        let notif_center = UNUserNotificationCenter.current()
        // Request permission to display alerts and play sounds.
        notif_center.requestAuthorization(options: [.alert, .sound])
        { (granted, error) in
            // Enable or disable features based on authorization.
        }
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
