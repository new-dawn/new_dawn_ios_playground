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
    
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var workLabel: UILabel!
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var smokeLabel: UILabel!
    @IBOutlet weak var drinkLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    
    @IBOutlet weak var questionLabel_1: UILabel!
    @IBOutlet weak var answerLabel_1: UILabel!
    @IBOutlet weak var deleteButton_1: UIButton!
    
    @IBOutlet weak var questionLabel_2: UILabel!
    @IBOutlet weak var answerLabel_2: UILabel!
    @IBOutlet weak var deleteButton_2: UIButton!

    @IBOutlet weak var questionLabel_3: UILabel!
    @IBOutlet weak var answerLabel_3: UILabel!
    @IBOutlet weak var deleteButton_3: UIButton!
    
    lazy var imageCV = ProfileImageUploadModel(photoCollectionView, self, 270)
    let sectionHeaderTitleArray = ["图片", "个人信息", " ", "我的问答"]
    @IBOutlet weak var personalAttribute: UIView!
    
    
    // Logic:
    // 1. Download all information from server, store them in local
    // 2. Override them in local when edit
    // 3. Send changes to server once leave the page
    
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
                    self.setupDefaultValue(profile: user_profile!)
                    if user_profile!.questionAnswers.count > 0{
                        self.setupQuestionAnswer(questionAnswers: user_profile!.questionAnswers)
                    }
                }
            }
        }
    }
    
    func setupQuestionAnswer(questionAnswers: Array<QuestionAnswer>){
        
        for (index, questionAnswer) in questionAnswers.enumerated(){
            if index == 0{
                questionLabel_1.text = questionAnswer.question.question
                answerLabel_1.text = questionAnswer.answer
            }
            if index == 1{
                questionLabel_2.text = questionAnswer.question.question
                answerLabel_2.text = questionAnswer.answer
            }
            if index == 2{
                questionLabel_3.text = questionAnswer.question.question
                answerLabel_3.text = questionAnswer.answer
            }
        }
    }
    
    func setupDefaultValue(profile: UserProfile){
        self.ageLabel.text = String(profile.age)
        self.firstNameLabel.text = profile.firstname
        self.heightLabel.text = String(profile.height)
        let employer_val = profile.employer == "N/A" ? "" : profile.employer
        let jobtitle_val = profile.jobTitle == "N/A" ? "" : profile.jobTitle
        let school_val = profile.school == "N/A" ? "" : profile.school
        let degree_val = profile.degree == "N/A" ? "" : profile.degree
        let smoke_val = profile.smoke == "N/A" ? "" : profile.smoke
        let drink_val = profile.drink == "N/A" ? "" : profile.drink
        let hometown_val = profile.hometown == "N/A" ? "" : profile.hometown
        self.workLabel.text = (employer_val == "" && jobtitle_val == "") ? "" : employer_val + " , " + jobtitle_val
        self.degreeLabel.text = (school_val == "" && degree_val == "") ? "" : school_val + " , " + degree_val
        self.smokeLabel.text = smoke_val
        self.drinkLabel.text = drink_val
        self.locationLabel.text = hometown_val
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
