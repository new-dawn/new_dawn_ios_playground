//
//  SettingPageViewController.swift
//  NewDawn
//
//  Created by 汤子毅 on 2019/1/13.
//  Copyright © 2019 New Dawn. All rights reserved.
//

import UIKit

class SettingPageViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var preferenceButton: UIButton!
//    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    
    @IBOutlet weak var NameAgeText: UILabel!
    @IBOutlet weak var HomeTownText: UILabel!
    
    
    // TODO: Display name, age and hometown
    override func viewDidLoad() {
        super.viewDidLoad()
        ImageUtil.polishCircularImageView(imageView: profileImage)
        
        // Move text up to the middle
        preferenceButton.titleEdgeInsets = UIEdgeInsets(top: -20.0, left: 0.0, bottom: 0.0, right: 0.0)
//        helpButton.titleEdgeInsets = UIEdgeInsets(top: -20.0, left: 0.0, bottom: 0.0, right: 0.0)
        settingButton.titleEdgeInsets = UIEdgeInsets(top: -20.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        // Draw Straight Line
        let draw = DrawLine(frame: CGRect(x: 60, y: 370, width: 250, height: 1))
        draw.backgroundColor = UIColor(white: 0.5, alpha: 0.1)
        view.addSubview(draw)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewLoadSetup()
    }
    
    func viewLoadSetup(){
        LoginUserUtil.fetchLoginUserProfile(readLocal: false) {
            user_profile, error in
            if error != nil {
                self.displayMessage(userMessage: "Error: Fetch Login User Profile Failed: \(error!)")
                LoginUserUtil.logout()
                return
            }
            // TODO: Have a helper function to check both login
            // user id and access token matching status
            if user_profile == nil && LoginUserUtil.getLoginUserId() != 1 {
                self.displayMessage(userMessage: "Error: User profile doesn't exist. This might mean that your profile has been deleted from database: \(error!)")
                LoginUserUtil.logout()
                return
            }
            if user_profile != nil {
                DispatchQueue.main.async {
                    let user_age = user_profile!.age
                    let user_firstname = user_profile!.firstname
                    let user_hometown = user_profile!.hometown
                    self.NameAgeText.text = user_firstname + ", " + String(user_age)
                    self.HomeTownText.text = user_hometown
                    if let images_count = LocalStorageUtil.localReadKeyValue(key: "ImagesCount"){
                        if user_profile!.mainImages.count == images_count as! Int {
                            self.profileImage.downloaded(from:
                                self.profileImage.getURL(path: user_profile!.mainImages[0].image_url))
                            EditProfileTabelViewController.downloadOverwriteLocalImages(profile: user_profile!)
                            EditProfileTabelViewController.downloadOverwriteLocalInfo(profile: user_profile!)
                        }else{
                            self.viewDidLoad()
                        }
                    }else{
                        if user_profile!.mainImages.isEmpty == false {
                            self.profileImage.downloaded(from:
                                self.profileImage.getURL(path: user_profile!.mainImages[0].image_url))
                            EditProfileTabelViewController.downloadOverwriteLocalImages(profile: user_profile!)
                            EditProfileTabelViewController.downloadOverwriteLocalInfo(profile: user_profile!)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func previewButtonTapped(_ sender: Any) {
        LoginUserUtil.fetchLoginUserProfile() {
            user_profile, error in
            if error != nil {
                DispatchQueue.main.async {
                    self.displayMessage(userMessage: "Error: Fetch Login User Profile Failed: \(error!)")
                }
                return
            }
            if user_profile != nil {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "myProfile", sender: user_profile)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let chatProfileController = segue.destination as? ChatProfileViewController {
            // Go to my profile
            if let sender = sender as? UserProfile {
                chatProfileController.user_profile = sender
            }
        }
    }
}


class DrawLine: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
