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
    
    @IBOutlet weak var NameAgeText: UILabel!
    @IBOutlet weak var HomeTownText: UILabel!
    
    
    // TODO: Display name, age and hometown
    override func viewDidLoad() {
        super.viewDidLoad()
        ImageUtil.polishCircularImageView(imageView: profileImage)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(gesture:)))// add it to the image view;
        profileImage.addGestureRecognizer(tapGesture)
        // make sure imageView can be interacted with by user
        profileImage.isUserInteractionEnabled = true
        
        // Move text up to the middle
        preferenceButton.titleEdgeInsets = UIEdgeInsets(top: -20.0, left: 0.0, bottom: 0.0, right: 0.0)
        accountButton.titleEdgeInsets = UIEdgeInsets(top: -20.0, left: 0.0, bottom: 0.0, right: 0.0)
        helpButton.titleEdgeInsets = UIEdgeInsets(top: -20.0, left: 0.0, bottom: 0.0, right: 0.0)
        settingButton.titleEdgeInsets = UIEdgeInsets(top: -20.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        // Draw Straight Line
        let draw = DrawLine(frame: CGRect(x: 60, y: 370, width: 250, height: 1))
        draw.backgroundColor = UIColor(white: 0.5, alpha: 0.1)
        view.addSubview(draw)
        
        LoginUserUtil.fetchLoginUserProfile() {
            user_profile in
            if user_profile != nil {
                if user_profile!.mainImages.isEmpty == false {
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
