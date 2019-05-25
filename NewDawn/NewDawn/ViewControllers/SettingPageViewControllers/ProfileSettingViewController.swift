//
//  ProfileSettingViewController.swift
//  NewDawn
//
//  Created by Junlin Liu on 2/10/19.
//  Copyright © 2019 New Dawn. All rights reserved.
//

import UIKit

class ProfileSettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    var switch_cells = ["账号", "系统通知"]
    let cellReuseIdentifier = "AccountCell"
    var icons = ["AccountSetting_Account", "AccountSetting_Notification"]
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var privacyButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Polish privacy button
        privacyButton.backgroundColor = UIColor.white
        privacyButton.layer.borderColor = UIColor(red:227/255, green:227/255, blue:227/255, alpha:1).cgColor
        privacyButton.layer.borderWidth = 2
        privacyButton.layer.cornerRadius = 25
        privacyButton.clipsToBounds = true
        let privacy_image = UIImage(named: "AccountSetting_Privacy")!
        privacyButton.setImage(privacy_image.withRenderingMode(.alwaysOriginal), for: .normal)
        privacyButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 35, bottom: 0, right: privacy_image.size.width * 3)
        privacyButton.contentHorizontalAlignment = .left
        privacyButton.imageView?.contentMode = .scaleAspectFit
        privacyButton.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 60.0, bottom: 0.0, right: 0.0)
        
        
        // Add straight line
        let draw = DrawLine(frame: CGRect(x: 40, y: 350, width: 300, height: 1))
        draw.backgroundColor = UIColor(white: 0.5, alpha: 0.1)
        view.addSubview(draw)
        
        // Set up collection view
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.switch_cells.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    // Spacing between cells
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:AccountSettingCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! AccountSettingCell
        
        cell.icon.image = UIImage(named: self.icons[indexPath.section])

        cell.label.text = self.switch_cells[indexPath.section]
        
        cell.backgroundColor = UIColor.white
        cell.layer.borderColor = UIColor(red:227/255, green:227/255, blue:227/255, alpha:1).cgColor
        cell.layer.borderWidth = 2
        cell.layer.cornerRadius = 25
        cell.clipsToBounds = true
        
        cell.switchButton.onTintColor = UIColor(red:92.0/255, green:117.0/255, blue:163.0/255, alpha:1)
        cell.switchButton.tintColor = UIColor(red:193.0/255, green:208.0/255, blue:215.0/255, alpha:1)

        cell.switchButton.tag = indexPath.section
        cell.switchButton.addTarget(self, action: #selector(toggle(_:)), for: .valueChanged)
        return cell
    }
    
    
    @objc func toggle(_ sender: UISwitch) {
        // Add action for different switches accordingly
        let cell = switch_cells[sender.tag]
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in sender.isOn = true}
        cancelAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        if cell == "账号" && sender.isOn == false {
            let alertController = UIAlertController(title: nil, message: "关闭帐号后你的帐号将不会显示在推送中。你确认要关闭你的帐号吗？", preferredStyle: .alert)
            alertController.setValue(NSAttributedString(string: alertController.message!,
                                                        attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold), NSAttributedString.Key.foregroundColor : UIColor.black]), forKey: "attributedMessage")
            let confirmAction = UIAlertAction(title: "Yes", style: .default) { (_) in
                // Add confirm action
            }
            confirmAction.setValue(UIColor.black, forKey: "titleTextColor")
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
        if cell == "系统通知" && sender.isOn == false{
            let alertController = UIAlertController(title: nil, message: "你可以在手机设定中将通知再打开。", preferredStyle: .alert)
            alertController.setValue(NSAttributedString(string: alertController.message!,
                                                        attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold), NSAttributedString.Key.foregroundColor : UIColor.black]), forKey: "attributedMessage")
            let confirmAction = UIAlertAction(title: "Go to Phone Settings", style: .default) { (_) in
                // Navigate to this app's notification center
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (_) in})
                }
            }
            confirmAction.setValue(UIColor.black, forKey: "titleTextColor")
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }

    @IBAction func backTabBarTapped(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "MainPage", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "MainTabViewController") as! UITabBarController
        self.present (vc, animated: true, completion: nil)
        vc.selectedIndex = 2
    }
    
    
    @IBAction func logOutButton(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: "Are you sure you want to log out?", preferredStyle: .alert)
        alertController.setValue(NSAttributedString(string: alertController.message!, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold), NSAttributedString.Key.foregroundColor : UIColor.black]), forKey: "attributedMessage")
        let confirmAction = UIAlertAction(title: "Log Out Now      ", style: .default) { (_) in
            if LoginUserUtil.logout() {
                // Take user to login page
                let loginStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                // Go to profile page
                DispatchQueue.main.async {
                    let loginPage = loginStoryboard.instantiateViewController(withIdentifier: "PhoneVerifyViewController")
                        as! PhoneVerifyViewController
                    let appDelegate = UIApplication.shared.delegate
                    appDelegate?.window??.rootViewController = loginPage
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in}
        cancelAction.setValue(UIColor.black, forKey: "titleTextColor")
        confirmAction.setValue(UIColor.black, forKey: "titleTextColor")
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}

