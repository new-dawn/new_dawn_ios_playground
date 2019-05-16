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
}
