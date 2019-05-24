//
//  PreferenceViewController.swift
//  NewDawn
//
//  Created by Junlin Liu on 4/17/19.
//  Copyright © 2019 New Dawn. All rights reserved.
//

import Foundation
import UIKit


class PreferenceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var clickable_filters = ["age_pref", "height_pref"]
    var clickable_filters_name = ["年龄范围", "身高范围"]
    var icons = [ "PreferenceAge_Icon", "PreferenceHeight_Icon"]
    @IBOutlet weak var prefTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        prefTableView.reloadData()
    }
    
    override func viewDidLoad() {
        prefTableView.dataSource = self
        prefTableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PrefSettingCell = self.prefTableView.dequeueReusableCell(withIdentifier: "pref_cell") as! PrefSettingCell
        
        
        // UI for Table View Layer
        cell.backgroundColor = UIColor.white
        cell.layer.borderColor = UIColor(red:151/255, green:151/255, blue:151/255, alpha:1).cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 20
        cell.clipsToBounds = true
        
        // UI for Table view Cell
        cell.prefname.text = self.clickable_filters_name[indexPath.section]
        cell.prefvalue.text = getPreferenceValue(pref: self.clickable_filters[indexPath.section])
        cell.icon.image = UIImage(named: self.icons[indexPath.section])
        cell.button.tag = indexPath.section
        cell.button.addTarget(self, action: #selector(sonView(_:)), for: .touchDown)
   
        
        return cell
    }
    
    func getPreferenceValue(pref: String) -> String{
        let stored_pref = LocalStorageUtil.localReadKeyValue(key: pref) ?? ""
        return stored_pref as! String
    }
    
    @objc func sonView(_ sender: UIButton){
        let son_view = clickable_filters[sender.tag]
        self.performSegue(withIdentifier: son_view, sender: self)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.clickable_filters.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
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
