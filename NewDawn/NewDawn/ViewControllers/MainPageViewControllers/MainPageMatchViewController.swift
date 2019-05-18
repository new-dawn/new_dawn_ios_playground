//
//  MainPageMatchViewController.swift
//  NewDawn
//
//  Created by 汤子毅 on 2019/5/15.
//  Copyright © 2019 New Dawn. All rights reserved.
//

import UIKit

class MainPageMatchViewController: UIViewController {
    @IBOutlet weak var yourProfilePhoto: UIImageView!
    @IBOutlet weak var firstNameAneAge: UILabel!
    @IBOutlet weak var yourCity: UILabel!
    
    var userProfile: UserProfile?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let yourUserProfile = userProfile {
            if let profilePhotoURL = yourUserProfile.mainImages.first {
                yourProfilePhoto.downloaded(from: yourProfilePhoto.getURL(path: profilePhotoURL.image_url))
            }
            firstNameAneAge.text = "\(yourUserProfile.firstname), \(yourUserProfile.age)"
            yourCity.text = "\(yourUserProfile.hometown)"
        }
    }
    func notifyMainPageSwipe() {
        // Update latest matched user id
        // to mute new match notification
        if let user_id = userProfile?.user_id {
            LocalStorageUtil.localStoreKeyValue(key: MATCHED_USER_ID, value: user_id)
        }
        // Tell the main page to swipe to the
        // next profile
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "likeButtonTappedOnPopupModal"), object: nil)
    }
    @IBAction func chatButtonTapped(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "MainPage", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "MainTabViewController") as! UITabBarController
        self.present (vc, animated: false, completion: nil)
        vc.selectedIndex = 1
        notifyMainPageSwipe()
    }
    @IBAction func stayButtonTapped(_ sender: Any) {
        dismiss(animated: true)
        notifyMainPageSwipe()
    }
}
