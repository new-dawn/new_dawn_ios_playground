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
    @IBOutlet weak var homeTownLabel: UILabel!
    
    
    @IBOutlet weak var questionLabel_1: UILabel!
    @IBOutlet weak var answerLabel_1: UILabel!
    @IBOutlet weak var deleteButton_1: UIButton!
    @IBOutlet weak var questionFrameButton_1: UIButton!
    
    @IBOutlet weak var questionLabel_2: UILabel!
    @IBOutlet weak var answerLabel_2: UILabel!
    @IBOutlet weak var deleteButton_2: UIButton!
    @IBOutlet weak var questionFrameButton_2: UIButton!

    @IBOutlet weak var questionLabel_3: UILabel!
    @IBOutlet weak var answerLabel_3: UILabel!
    @IBOutlet weak var deleteButton_3: UIButton!
    @IBOutlet weak var questionFrameButton_3: UIButton!
    
    lazy var imageCV = ProfileImageUploadModel(photoCollectionView, self, 270)
    let sectionHeaderTitleArray = ["图片", "个人信息", " ", "我的问答"]
    @IBOutlet weak var personalAttribute: UIView!
    
    
    // Logic:
    // 1. Download all information from server, store them in local
    // 2. Override them in local when edit
    // 3. Send changes to server once leave the page
    
    override func viewDidLoad() {
        overrideBackbutton()
        self.tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupPersonalInfo()
        self.setupPhotoCollection()
        self.setupQuestionAnswer()
    }
    
    func overrideBackbutton(){
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "< Setting", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    
    @objc func back(sender: UIBarButtonItem) {
        // Get information from local and send to server
        // Go back to the root ViewController
        let request = EditProfileUtil.createRegistrationRequest()
        
        // Warning amount of photos
        let dataPath = ImageUtil.getPersonalImagesDirectory()
        var stored_files = try?FileManager.default.contentsOfDirectory(atPath: dataPath)
        stored_files = stored_files?.filter{$0 != ".DS_Store"}
        if (stored_files!.count < 3) {
            self.displayMessage(userMessage: "为了帮助你配对，请最少上传3张符合要求的照片喔。")
            return
        }
        
        if let first_name = LocalStorageUtil.localReadKeyValue(key: FIRSTNAME), let last_name = LocalStorageUtil.localReadKeyValue(key: LASTNAME), let birthday = LocalStorageUtil.localReadKeyValue(key: BIRTHDAY), let height = LocalStorageUtil.localReadKeyValue(key: HEIGHT){
            if first_name as! String == "" || last_name as! String == ""{
                self.displayMessage(userMessage: "姓名不能为空")
                return
            }
            if birthday as! String == ""{
                self.displayMessage(userMessage: "生日不能为空")
                return
            }
            if height as! String == ""{
                self.displayMessage(userMessage: "身高不能为空")
                return
            }
        }else{
            self.displayMessage(userMessage: "身份信息不能为空")
            return
        }
        
        if request == nil {
            return
        }
        sender.isEnabled = false
        let activityIndicator = self.prepareActivityIndicator()
        self.processSessionTasks(request: request!){
            register_response in
            if let images = ImageUtil.getPersonalImagesWithData(), images.count != 0{
                var images_count = 0
                for single_image in images{
                    let single_img = single_image["img"]
                    let single_params = [
                        "order": single_image["order"] ?? UNKNOWN,
                        "caption": single_image["caption"] ?? UNKNOWN,
                        "user": single_image["user_uri"] ?? UNKNOWN
                        ] as [String: Any]
                    let img_name = String.MD5(String(single_image["user_id"] as! Int) + String(single_image["order"] as! Int))! + ".jpeg"
                    ImageUtil.photoUploader(photo: single_img as! UIImage, filename: img_name, parameters: single_params){ success in
                        images_count = images_count + 1
                        // TODO: Handle unsuccessful upload
                         print("image upload \(success)")
                        if images_count == images.count{
                            // AWS seems to take some time to generate photos URL, even if uploads successfully
                            // Use a local storage value to keep track of fetched photos
                            LocalStorageUtil.localStoreKeyValue(key: "ImagesCount", value: images_count)
                            self.removeActivityIndicator(activityIndicator: activityIndicator)
                            self.dismiss(animated: true, completion: {})
                            self.navigationController?.popViewController(animated: true)
                        }}
                }
            }else{
                self.removeActivityIndicator(activityIndicator: activityIndicator)
                self.dismiss(animated: true, completion: {})
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    static func downloadOverwriteLocalImages(profile: UserProfile){
        let dataPath = ImageUtil.getPersonalImagesDirectory()
        LocalStorageUtil.checkFolderExistOrCreate(dataPath: dataPath)
        LocalStorageUtil.cleanDirectory(directory: "PersonalImages")
        for (index, image) in profile.mainImages.enumerated(){
            let image_name = String(index)
            var fileURL = URL(fileURLWithPath:dataPath).appendingPathComponent(image_name)
            ImageUtil.downLoadImage(url: image.image_url){
                image in
                if let imageData = image.jpegData(compressionQuality: 1){
                    fileURL = fileURL.appendingPathExtension("jpeg")
                    do{
                        try imageData.write(to: fileURL, options: .atomic)
                    }catch{
                        print ("error", error)
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
    
    
    static func downloadOverwriteLocalInfo(profile: UserProfile){
        LocalStorageUtil.localStoreKeyValue(key: FIRSTNAME, value: profile.firstname)
        LocalStorageUtil.localStoreKeyValue(key: LASTNAME, value: profile.lastname)
        LocalStorageUtil.localStoreKeyValue(key: USERNAME, value: profile.username)
        LocalStorageUtil.localStoreKeyValue(key: HEIGHT, value: String(profile.height))
        LocalStorageUtil.localStoreKeyValue(key: AGE, value: String(profile.age))
        LocalStorageUtil.localStoreKeyValue(key: GENDER, value: String(profile.gender))
        LocalStorageUtil.localStoreKeyValue(key: BIRTHDAY, value: String(profile.birthday))
        LocalStorageUtil.localStoreKeyValue(key: HOMETOWN, value: profile.hometown)
        LocalStorageUtil.localStoreKeyValue(key: LOCATION, value: profile.location)
        LocalStorageUtil.localStoreKeyValue(key: SCHOOL, value: profile.school)
        LocalStorageUtil.localStoreKeyValue(key: DEGREE, value: profile.degree)
        LocalStorageUtil.localStoreKeyValue(key: JOBTITLE, value: profile.jobTitle)
        LocalStorageUtil.localStoreKeyValue(key: WORKPLACE, value: profile.employer)
        LocalStorageUtil.localStoreKeyValue(key: DRINK, value: profile.drink)
        LocalStorageUtil.localStoreKeyValue(key: SMOKE, value: profile.smoke)
        LocalStorageUtil.localStoreKeyValueStruct(key: QUESTION_ANSWERS, value: profile.questionAnswers)
    }
    
    func setupQuestionAnswer(){
        if let existed_question_answers: Array<QuestionAnswer> = LocalStorageUtil.localReadKeyValueStruct(key: QUESTION_ANSWERS) {
            for (index, questionAnswer) in existed_question_answers.enumerated(){
                if index == 0{
                    questionLabel_1.text = questionAnswer.question.question
                    answerLabel_1.text = questionAnswer.answer
                    deleteButton_1.tag = questionAnswer.question.id + 1000
                    deleteButton_1.addTarget(self, action: #selector(deleteQ), for: .allTouchEvents)
                    questionFrameButton_1.isUserInteractionEnabled = false
                }
                if index == 1{
                    questionLabel_2.text = questionAnswer.question.question
                    answerLabel_2.text = questionAnswer.answer
                    deleteButton_2.tag = questionAnswer.question.id + 2000
                    deleteButton_2.addTarget(self, action: #selector(deleteQ), for: .allTouchEvents)
                    questionFrameButton_2.isUserInteractionEnabled = false
                }
                if index == 2{
                    questionLabel_3.text = questionAnswer.question.question
                    answerLabel_3.text = questionAnswer.answer
                    deleteButton_3.tag = questionAnswer.question.id + 3000
                    deleteButton_3.addTarget(self, action: #selector(deleteQ), for: .allTouchEvents)
                    questionFrameButton_3.isUserInteractionEnabled = false
                }
            }
        }
    }
    
    @objc func deleteQ(sender: UIButton) {
        let q_id = sender.tag % 1000
        let cell_id = Int(sender.tag / 1000)
        removeQuestionAnswerFromLocalStore(q_id: q_id)
        removeQuestionText(cell_id: cell_id)
        self.viewDidLoad()
    }
    
    func removeQuestionText(cell_id: Int){
        if cell_id == 1{
            questionLabel_1.text = ""
            answerLabel_1.text = ""
            deleteButton_1.removeTarget(self, action: #selector(deleteQ), for: .allTouchEvents)
            questionFrameButton_1.isUserInteractionEnabled = true
        }
        if cell_id == 2{
            questionLabel_2.text = ""
            answerLabel_2.text = ""
            deleteButton_2.removeTarget(self, action: #selector(deleteQ), for: .allTouchEvents)
            questionFrameButton_2.isUserInteractionEnabled = true
        }
        if cell_id == 3{
            questionLabel_3.text = ""
            answerLabel_3.text = ""
            deleteButton_3.removeTarget(self, action: #selector(deleteQ), for: .allTouchEvents)
            questionFrameButton_3.isUserInteractionEnabled = true
        }
    }
    
    func removeQuestionAnswerFromLocalStore(q_id: Int) -> Void {
        // Remove the answered question from local storage
        if var existed_question_answers: Array<QuestionAnswer> = localReadKeyValueStruct(key: QUESTION_ANSWERS) {
            var index = -1
            for question_answer in existed_question_answers {
                index = index + 1
                if question_answer.question.id == q_id {
                    break
                }
            }
            if index != -1 {
                existed_question_answers.remove(at: index)
            }
            localStoreKeyValueStruct(key: QUESTION_ANSWERS, value: existed_question_answers)
        }
    }

    
    func setupPersonalInfo(){
        self.ageLabel.text = localReadKeyValue(key: AGE) as? String
        self.firstNameLabel.text = localReadKeyValue(key: FIRSTNAME) as? String
        self.heightLabel.text = localReadKeyValue(key: HEIGHT) as? String
        let employer_val = localReadKeyValue(key: WORKPLACE) as? String == UNKNOWN ? "" : localReadKeyValue(key: WORKPLACE) as? String
        let jobtitle_val = localReadKeyValue(key: JOBTITLE) as? String == UNKNOWN ? "" : localReadKeyValue(key: JOBTITLE) as? String
        let school_val = localReadKeyValue(key: SCHOOL) as? String == UNKNOWN ? "" : localReadKeyValue(key: SCHOOL) as? String
        let degree_val = localReadKeyValue(key: DEGREE) as? String == UNKNOWN ? "" : localReadKeyValue(key: DEGREE) as? String
        let smoke_val = localReadKeyValue(key: SMOKE) as? String == UNKNOWN ? "" : localReadKeyValue(key: SMOKE) as? String
        let drink_val = localReadKeyValue(key: DRINK) as? String == UNKNOWN ? "" : localReadKeyValue(key: DRINK) as? String
        let hometown_val = localReadKeyValue(key: HOMETOWN) as? String == UNKNOWN ? "" : localReadKeyValue(key: HOMETOWN) as? String
        let location_val = localReadKeyValue(key: LOCATION) as? String == UNKNOWN ? "" : localReadKeyValue(key: LOCATION) as? String
        
        self.degreeLabel.text = (school_val == "" && degree_val == "") ? "" : (school_val ?? "") + " , " + (degree_val ?? "")
        self.workLabel.text = (employer_val == "" && jobtitle_val == "") ? "" : (employer_val ?? "") + " , " + (jobtitle_val ?? "")
        self.smokeLabel.text = smoke_val
        self.drinkLabel.text = drink_val
        self.locationLabel.text = location_val
        self.homeTownLabel.text = hometown_val
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
