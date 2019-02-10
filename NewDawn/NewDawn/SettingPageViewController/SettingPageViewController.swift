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
        ImageUtil.roundImageView(imageView: profileImage)
        polishUIButton(button: preferenceButton)
        polishUIButton(button: accountButton)
        polishUIButton(button: helpButton)
        polishUIButton(button: settingButton)
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
