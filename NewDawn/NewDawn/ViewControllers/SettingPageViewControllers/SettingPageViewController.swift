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
    @IBOutlet weak var accountButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ImageUtil.polishCircularImageView(imageView: profileImage)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(gesture:)))// add it to the image view;
        profileImage.addGestureRecognizer(tapGesture)
        // make sure imageView can be interacted with by user
        profileImage.isUserInteractionEnabled = true
    
        polishUIButton(button: preferenceButton)
        polishUIButton(button: accountButton)
        polishUIButton(button: helpButton)
        polishUIButton(button: settingButton)
        
        LoginUserUtil.fetchLoginUserProfile() {
            user_profile in
            if user_profile != nil {
                if user_profile?.mainImages.isEmpty ?? nil != nil {
                    self.profileImage.downloaded(from:
                        self.profileImage.getURL(path: user_profile!.mainImages[0].image_url))
                }
            }
        }
    }
    
    @objc func imageTapped(gesture: UIGestureRecognizer) {
        // if the tapped view is a UIImageView then set it to imageview
        if (gesture.view as? UIImageView) != nil {
            LoginUserUtil.fetchLoginUserProfile() {
                user_profile in
                if user_profile != nil {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "myProfile", sender: user_profile)
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Prepare fields sent to next page
        let chatProfileController = segue.destination as! ChatProfileViewController
        if let sender = sender as? UserProfile {
            chatProfileController.user_profile = sender
        }
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
