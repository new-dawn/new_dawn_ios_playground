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

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true

        // Check if reload is needed and refresh the main page if necessary
        // TODO: Remove "force = true" since it will always refresh the main page
        
        startTimer()
        // Check refresh again when user resume the app on ending page
        NotificationCenter.default.addObserver(self, selector: #selector(UIViewController.checkMainPageReload), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    func startTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(TEST_MAIN_PAGE_REFRESH_TIME), execute: {
            self.notifyNewCandidates()
        })
    }
    
    func notifyNewCandidates(){
        let alertController = UIAlertController(title: nil, message: "新的推荐已经产生", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "快去看看", style: .default) { (_) in
            self.checkMainPageReload(true)
        }
        confirmAction.setValue(UIColor.black, forKey: "titleTextColor")
        let cancelAction = UIAlertAction(title: "一会再说", style: .cancel) { (_) in
            self.startTimer()
        }
        cancelAction.setValue(UIColor.black, forKey: "titleTextColor")
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
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
