//
//  EditProfileViewController.swift
//  NewDawn
//
//  Created by Junlin Liu on 6/9/19.
//  Copyright © 2019 New Dawn. All rights reserved.
//

import Foundation
import UIKit

class EditProfileTabelViewController: UITableViewController{
    
    @IBOutlet var photoCollectionView: UICollectionView!
    lazy var imageCV = ProfileImageUploadModel(photoCollectionView, self, 270)
    let sectionHeaderTitleArray = ["图片", "个人信息", " ", "我的问答"]
    @IBOutlet weak var personalAttribute: UIView!
    
    override func viewDidLoad() {
        setupPhotoCollection()
        self.tableView.separatorStyle = .none
        LoginUserUtil.fetchLoginUserProfile(readLocal: false) {
            user_profile, error in
            if error != nil {
                self.displayMessage(userMessage: "Error: Fetch Login User Profile Failed: \(error!)")
                LoginUserUtil.logout()
                return
            }
            if user_profile != nil {
                DispatchQueue.main.async {
                    let user_age = user_profile!.age
                    let user_firstname = user_profile!.firstname
                    let user_hometown = user_profile!.hometown
                }
            }
        }
    }
    
    func setupPhotoCollection(){
        photoCollectionView.delegate = imageCV
        photoCollectionView.dataSource = imageCV
        photoCollectionView.dragInteractionEnabled = true
        photoCollectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "imageCell")
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0{
            let returnedView = UIView(frame: CGRect(x: 200, y: 25, width: 100, height: 50))
            returnedView.backgroundColor = .white
            
            let label = UILabel(frame: CGRect(x: 170, y: 5, width: 100, height: 50))
            label.font = UIFont(name: "PingFangTC-Medium", size: 16)
            label.text = self.sectionHeaderTitleArray[section]
            returnedView.addSubview(label)
            
            return returnedView
        }else{
            let returnedView = UIView(frame: CGRect(x: 200, y: 25, width: 100, height: 50))
            returnedView.backgroundColor = .white
            
            let label = UILabel(frame: CGRect(x: 150, y: -15, width: 100, height: 50))
            label.font = UIFont(name: "PingFangTC-Medium", size: 16)
            label.text = self.sectionHeaderTitleArray[section]
            returnedView.addSubview(label)
            
            return returnedView
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1{
            return 5
        }else{
            return 20
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let returnedView = UIView(frame: CGRect(x: 200, y: 25, width: 100, height: 50))
        returnedView.backgroundColor = .white
        return returnedView
    }
    
}
