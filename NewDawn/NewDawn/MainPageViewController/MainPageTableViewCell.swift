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
    
    var item: MainPageViewModellItem? {
        didSet {
            guard let item = item as? QuestionAnswerViewModelItem else { return }
            questionLabel?.text = item.question
            answerLabel?.text = item.answer
            name = item.name
        }
    }
    
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        let castItem = item as! QuestionAnswerViewModelItem
        LocalStorageUtil.localStoreKeyValue(
            key: LATEST_LIKED_ITEM, value: [
                QUESTION: castItem.question,
                ANSWER: castItem.answer,
            ])
        LocalStorageUtil.localStoreKeyValue(key: LATEST_LIKED_USER_NAME, value: name)
    }
}

class MainImageViewCell: UITableViewCell {
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var firstNameAndAge: UILabel!
    @IBOutlet weak var jobTitle: UILabel!
    @IBOutlet weak var employer: UILabel!
    var name: String!
    var item: MainPageViewModellItem? {
        didSet {
            guard let item = item as? MainImageViewModelItem else { return }
            
            // Display the image
            mainImageView!.downloaded(from: mainImageView!.getURL(path: item.mainImageURL))
            mainImageView!.clipsToBounds = true
            
            // Populate the profile name
            name = item.name
            
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
        let castItem = item as! MainImageViewModelItem
        LocalStorageUtil.localStoreKeyValue(
            key: LATEST_LIKED_ITEM, value: [
                IMAGE_URL: castItem.mainImageURL,
            ])
        LocalStorageUtil.localStoreKeyValue(key: LATEST_LIKED_USER_NAME, value: name)
    }
}
