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
        mySwitch.addTarget(self, action: #selector(toggel(_:)), for: .valueChanged)
        cell.accessoryView = mySwitch
        return cell
    }
    
    @objc func toggel(_ sender: UISwitch) {
        // Add action for different switches accordingly
    }
    
}
