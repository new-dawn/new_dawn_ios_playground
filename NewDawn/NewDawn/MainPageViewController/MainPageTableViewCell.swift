//
//  MainPageTableViewCell.swift
//  NewDawn
//
//  Created by 汤子毅 on 2019/1/6.
//  Copyright © 2019 New Dawn. All rights reserved.
//

import UIKit

let CM = " cm"
let LATEST_LIKED_ITEM = "latest_liked_item"
let LATEST_LIKED_USER_NAME = "latest_liked_user_name"
let LATEST_LIKED_ACCOUNT_ID = "latest_liked_account_id"
let ENTITY_TYPE = "entity_type"
let ENTITY_ID = "entity_id"
let ACTION_TYPE = "action_type"

class MainPageTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

class BasicInfoViewCell: UITableViewCell {
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var smokeLabel: UILabel!
    @IBOutlet weak var drinkLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var degreeLabel: UILabel!
    
    var item: MainPageViewModellItem? {
        didSet {
            guard let item = item as? BasicInfoViewModelItem else { return }
            locationLabel?.text = item.location
            smokeLabel?.text = item.smoke
            drinkLabel?.text = item.drink
            heightLabel?.text = String(item.height) + CM
            degreeLabel?.text = item.degree
        }
    }
}

class QuestionAnswerViewCell: UITableViewCell {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    var name: String!
    var account_id: String!
    var id: Int!
    
    var item: MainPageViewModellItem? {
        didSet {
            guard let item = item as? QuestionAnswerViewModelItem else { return }
            questionLabel?.text = item.question
            answerLabel?.text = item.answer
            name = item.name
            account_id = item.account_id
            id = item.id
        }
    }
    
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        let castItem = item as! QuestionAnswerViewModelItem
        LocalStorageUtil.localStoreKeyValue(
            key: LATEST_LIKED_ITEM, value: [
                QUESTION: castItem.question,
                ANSWER: castItem.answer,
                ENTITY_ID: castItem.id,
                ACTION_TYPE: UserActionType.LIKE.rawValue,
                ENTITY_TYPE: MainPageViewModelItemType.QUESTION_ANSWER.rawValue
            ])
        LocalStorageUtil.localStoreKeyValue(key: LATEST_LIKED_USER_NAME, value: name)
        LocalStorageUtil.localStoreKeyValue(key: LATEST_LIKED_ACCOUNT_ID, value: account_id)
    }
}

class MainImageViewCell: UITableViewCell {
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var firstNameAndAge: UILabel!
    @IBOutlet weak var jobTitle: UILabel!
    @IBOutlet weak var employer: UILabel!
    var name: String!
    var account_id: String!
    var id: Int!
    var item: MainPageViewModellItem? {
        didSet {
            // Remove current image
            mainImageView!.image = nil
            
            guard let item = item as? MainImageViewModelItem else { return }
            
            // Display the image
            mainImageView!.downloaded(from: mainImageView!.getURL(path: item.mainImageURL))
            mainImageView!.clipsToBounds = true
            
            // Populate the profile name
            name = item.name
            account_id = item.account_id
            id = item.id
            if item.isFirst == true {
                // Display the gradient
                mainImageView.layer.sublayers = nil
                mainImageView.layer.addSublayer(createGradientLayer())
                
                // Populate the profile first name
                if let nameArr = name?.components(separatedBy: " ") {
                    firstNameAndAge?.text = nameArr[0] + ". " + String(item.age)
                }
                
                // Populate Jobs
                jobTitle?.text = item.jobTitle
                employer?.text = item.employer
            } else {
                mainImageView.layer.sublayers = nil
                firstNameAndAge?.text = ""
                jobTitle?.text = ""
                employer?.text = ""
            }
        }
    }
    
    func createGradientLayer() -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = mainImageView.bounds
        gradientLayer.colors = [UIColor.black.withAlphaComponent(0).cgColor, UIColor.black.withAlphaComponent(1).cgColor]
        gradientLayer.opacity = 1.0
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.50)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        return gradientLayer
    }

    @IBAction func likeButtonTapped(_ sender: UIButton) {
        // TODO: should be retrieved from localstorage in the future
        let castItem = item as! MainImageViewModelItem
        LocalStorageUtil.localStoreKeyValue(
            key: LATEST_LIKED_ITEM, value: [
                IMAGE_URL: castItem.mainImageURL,
                ENTITY_ID: castItem.id,
                ACTION_TYPE: UserActionType.LIKE.rawValue,
                ENTITY_TYPE: MainPageViewModelItemType.MAIN_IMAGE.rawValue
            ])
        LocalStorageUtil.localStoreKeyValue(key: LATEST_LIKED_USER_NAME, value: name)
        LocalStorageUtil.localStoreKeyValue(key: LATEST_LIKED_ACCOUNT_ID, value: account_id)
    }
    
}
