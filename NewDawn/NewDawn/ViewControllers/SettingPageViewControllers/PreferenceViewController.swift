//
//  PreferenceViewController.swift
//  NewDawn
//
//  Created by Junlin Liu on 4/17/19.
//  Copyright © 2019 New Dawn. All rights reserved.
//

import Foundation
import UIKit

let gender_pref = "GENDER_PREF"
let distance_pref = "DISTANCE_PREF"
let age_pref = "AGE_PREF"
let height_pref = "HEIGHT_PREF"
let education_pref = "EDUCATION_PREF"

class PreferenceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var clickable_fitlers = ["Gender", "Distance", "Age Range", "Height", "Education"]

    @IBOutlet weak var prefTableView: UITableView!
    
    override func viewDidLoad() {
        self.prefTableView.register(UITableViewCell.self, forCellReuseIdentifier: "pref_cell")
        prefTableView.dataSource = self
        prefTableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.prefTableView.dequeueReusableCell(withIdentifier: "pref_cell")!
        cell.textLabel?.text = clickable_fitlers[indexPath.section]
        
        // UI for table view cells
        cell.textLabel?.font = UIFont(name:"PingFangTC-Semibold", size: 18.0)
        cell.backgroundColor = UIColor.white
        cell.layer.borderColor = UIColor(red:151/255, green:151/255, blue:151/255, alpha:1).cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 20
        cell.clipsToBounds = true
        
        // UIButton for subsidiary view
        let pref_button = UIButton(frame: CGRect(x: 1, y: 1, width: 48, height: 20))
        pref_button.tintColor = UIColor(red:193/255, green:199/255, blue:208/255, alpha:1)
        pref_button.tintColor = UIColor(red:151/255, green:151/255, blue:151/255, alpha:1)
        
        // Get pref from local storage or default text
        let accessory_text = LocalStorageUtil.localReadKeyValue(key: clickable_fitlers[indexPath.section] + "_PREF") ?? "Add Preference"
        pref_button.setTitle((accessory_text as! String),for: .normal)
        pref_button.setTitleColor(UIColor.gray, for: .normal)
        let rect = CGRect(x: 20, y: 100, width: 150, height: 100)
        pref_button.tag = indexPath.section
        pref_button.addTarget(self, action: #selector(sonView(_:)), for: .touchDown)
        cell.accessoryView = pref_button
        cell.accessoryView?.frame = rect
        
        return cell
    }
    
    @objc func sonView(_ sender: UIButton){
        let son_view = clickable_fitlers[sender.tag] + "_PREF"
        self.performSegue(withIdentifier: son_view, sender: self)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.clickable_fitlers.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 11
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
}
