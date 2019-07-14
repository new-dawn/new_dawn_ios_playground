//
//  MainPageTabBarViewController.swift
//  NewDawn
//
//  Created by 汤子毅 on 2019/1/10.
//  Copyright © 2019 New Dawn. All rights reserved.
//

import UIKit

class MainPageTabBarViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.tabBar.items?.first?.badgeColor = .red
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return (viewController != tabBarController.selectedViewController);
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let params = ["user_from": String(LoginUserUtil.getLoginUserId()!),
                      "action_type": String(UserActionType.MATCH.rawValue)]
        let check_matched_url = HttpUtil.getURL(path: "user_action/" + HttpUtil.encodeParams(raw_params: params))
        var request = URLRequest(url:check_matched_url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        self.processSessionTasks(request: request, callback: checkMatchedUsers)
    }
    
    func notifyNewMatch(){
        let alertController = UIAlertController(title: nil, message: "You have a new Match", preferredStyle: .alert)
        var confirmAction: UIAlertAction;
        if self.selectedIndex != 1{
            confirmAction = UIAlertAction(title: "Check It Out", style: .default) { (_) in
                DispatchQueue.main.async {
                    let storyBoard = UIStoryboard(name: "MainPage", bundle: nil)
                    let vc = storyBoard.instantiateViewController(withIdentifier: "MainTabViewController") as! UITabBarController
                    self.present (vc, animated: false, completion: nil)
                    vc.selectedIndex = 1
                }
            }
        }else{
            confirmAction = UIAlertAction(title: "Check It Out", style: .default)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in}
        cancelAction.setValue(UIColor.black, forKey: "titleTextColor")
        confirmAction.setValue(UIColor.black, forKey: "titleTextColor")
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func checkMatchedUsers(jsonResponse: NSDictionary, error: String?) -> Void{
        let objects = jsonResponse["objects"] as! [[String: Any]]
        let upto_date_matched_users_dicts = objects.map{$0["user_to"]!} as! [[String: Any]]
        let upto_date_matched_users_id = upto_date_matched_users_dicts.map{$0["id"]!} as! [Int]
        if let stored_match_ids = LocalStorageUtil.localReadKeyValue(key: MATCHED_USER_ID) as? [Int]{
            if upto_date_matched_users_id.count > stored_match_ids.count{
                notifyNewMatch()
            }
        }
        LocalStorageUtil.localStoreKeyValue(key: MATCHED_USER_ID, value: upto_date_matched_users_id)
    }
}
