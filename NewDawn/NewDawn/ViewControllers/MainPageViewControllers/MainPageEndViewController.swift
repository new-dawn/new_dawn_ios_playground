//
//  MainPageEndViewController.swift
//  NewDawn
//
//  Created by 汤子毅 on 2019/1/16.
//  Copyright © 2019 New Dawn. All rights reserved.
//

import UIKit

class MainPageEndViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true

        // Check if reload is needed and refresh the main page if necessary
        // TODO: Remove "force = true" since it will always refresh the main page
        self.checkMainPageReload(true)

        // Check refresh again when user resume the app on ending page
        NotificationCenter.default.addObserver(self, selector: #selector(UIViewController.checkMainPageReload), name: UIApplication.willEnterForegroundNotification, object: nil)
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
