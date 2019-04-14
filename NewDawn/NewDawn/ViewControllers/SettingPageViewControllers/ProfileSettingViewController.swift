//
//  ProfileSettingViewController.swift
//  NewDawn
//
//  Created by Junlin Liu on 2/10/19.
//  Copyright © 2019 New Dawn. All rights reserved.
//

import UIKit

class ProfileSettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    var switch_cells = ["Account", "Chat Notification"]
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var popOutView: UIView!
    @IBOutlet weak var privacyButton: UIButton!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        polishUIButton(button: privacyButton)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        popOutView.isHidden = true
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
        return 11
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        // set table view cell style
        cell.textLabel?.text = switch_cells[indexPath.section]
        cell.textLabel?.font = UIFont(name:"PingFangTC-Semibold", size: 18.0)
        cell.backgroundColor = UIColor.white
        cell.layer.borderColor = UIColor(red:151/255, green:151/255, blue:151/255, alpha:1).cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 20
        cell.clipsToBounds = true
        
        // Add UI Switch button
        let mySwitch = UISwitch(frame: CGRect(x: 1, y: 1, width: 48, height: 20))
        mySwitch.isOn = true
        mySwitch.onTintColor = UIColor(red:193/255, green:199/255, blue:208/255, alpha:1)
        mySwitch.tintColor = UIColor(red:151/255, green:151/255, blue:151/255, alpha:1)
        mySwitch.tag = indexPath.section
        mySwitch.addTarget(self, action: #selector(toggle(_:)), for: .valueChanged)
        cell.accessoryView = mySwitch
        return cell
    }
    
    
    @objc func toggle(_ sender: UISwitch) {
        // Add action for different switches accordingly
        let cell = switch_cells[sender.tag]
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in sender.isOn = true}
        cancelAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        if cell == "Account" && sender.isOn == false {
            let alertController = UIAlertController(title: nil, message: "You won’t show up on MM’s feed anymore, while you can still chat with connected people.", preferredStyle: .alert)
            alertController.setValue(NSAttributedString(string: alertController.message!,
                                                        attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold), NSAttributedString.Key.foregroundColor : UIColor.black]), forKey: "attributedMessage")
            let confirmAction = UIAlertAction(title: "Turn off Account", style: .default) { (_) in
                // Add confirm action
            }
            confirmAction.setValue(UIColor.black, forKey: "titleTextColor")
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
        if cell == "Chat Notification" && sender.isOn == false{
            let alertController = UIAlertController(title: nil, message: "You can turn on nitification in Phone Settings ", preferredStyle: .alert)
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
}
