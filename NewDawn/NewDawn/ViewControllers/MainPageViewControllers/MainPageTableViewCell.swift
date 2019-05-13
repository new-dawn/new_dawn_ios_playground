//
//  MainPageTableViewCell.swift
//  NewDawn
//
//  Created by 汤子毅 on 2019/1/6.
//  Copyright © 2019 New Dawn. All rights reserved.
//

import UIKit

let CM = " cm"

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

class LikeImageViewCell: UITableViewCell {
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var likeMessage: UITextView!
    @IBOutlet weak var likeImageView: UIImageView!
    
    var item: MainPageViewModellItem? {
        didSet {
            guard let item = item as? LikeImageViewModelItem else { return }
            likeLabel?.text = item.likerFirstName + " likes your photo!"
            likeMessage?.text = item.likedMessage
            likeImageView!.clipsToBounds = true
            likeImageView!.downloaded(from: likeImageView!.getURL(path: item.likedImageURL))
        }
    }
}

class LikeAnswerViewCell: UITableViewCell {
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var likeAnswer: UITextView!
    @IBOutlet weak var likeMessage: UITextView!
    
    var item: MainPageViewModellItem? {
        didSet {
            guard let item = item as? LikeAnswerViewModelItem else { return }
            likeLabel?.text = item.likerFirstName + " likes your answer!"
            likeMessage?.text = item.likedMessage
            likeAnswer?.text = item.likedAnswer
        }
    }
}

class LikeMeViewCell: UITableViewCell {
    
    @IBOutlet weak var likeMeButton: UIButton!
    var item: MainPageViewModellItem? {
        didSet {
            guard let item = item as? LikeMeViewModelItem else { return }
            if item.likedInfo.liked_entity_type == EntityType.MAIN_IMAGE.rawValue {
                likeMeButton.setTitle("\(item.likerFirstName) 喜欢你的图片，想对你说...", for: .normal)
            }
            if item.likedInfo.liked_entity_type == EntityType.QUESTION_ANSWER.rawValue {
                likeMeButton.setTitle("\(item.likerFirstName) 喜欢你的回答，想对你说...", for: .normal)
            }
            
        }
    }
}

class BasicInfoViewCell: UITableViewCell {
    
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var smokeLabel: UILabel!
    @IBOutlet weak var drinkLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var workLabel: UILabel!
    
    var item: MainPageViewModellItem? {
        didSet {
            guard let item = item as? BasicInfoViewModelItem else { return }
            locationLabel?.text = item.location
            smokeLabel?.text = item.smoke
            drinkLabel?.text = item.drink
            heightLabel?.text = String(item.height)
            degreeLabel?.text = item.degree
            firstNameLabel?.text = item.firstName
            workLabel?.text = item.jobTitle + ", " + item.employer
            ageLabel?.text = String(item.age)
        }
    }
}

class QuestionAnswerViewCell: UITableViewCell {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    var name: String!
    var user_id: String!
    var id: Int!
    
    var item: MainPageViewModellItem? {
        didSet {
            guard let item = item as? QuestionAnswerViewModelItem else { return }
            questionLabel?.numberOfLines = 0
            questionLabel?.lineBreakMode = .byWordWrapping
            questionLabel?.text = item.question
            questionLabel?.frame.size.width = 300
            questionLabel?.sizeToFit()
            answerLabel?.numberOfLines = 0
            answerLabel?.lineBreakMode = .byWordWrapping
            answerLabel?.text = item.answer
            answerLabel?.frame.size.width = 300
            answerLabel?.sizeToFit()
            name = item.name
            user_id = item.user_id
            id = item.id
        }
    }
    
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        let castItem = item as! QuestionAnswerViewModelItem
        LikeInfoUtil.storeLatestLikeYouInfo(
            LikeYouInfo(
                user_id,
                latest_liked_user_name: name,
                entity_id: castItem.id,
                question: castItem.question,
                answer: castItem.answer
            )
        )
    }
}

class MainImageViewCell: UITableViewCell {
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var firstNameAndAge: UILabel!
    @IBOutlet weak var jobTitle: UILabel!
    @IBOutlet weak var employer: UILabel!
    var name: String!
    var user_id: String!
    var id: Int!
    var item: MainPageViewModellItem? {
        didSet {
            // Remove current image
            mainImageView!.image = nil
            
            guard let item = item as? MainImageViewModelItem else { return }
            
            // Populate the profile name
            name = item.name
            user_id = item.user_id
            id = item.id
            
            mainImageView.layer.sublayers = nil
            firstNameAndAge?.text = ""
            jobTitle?.text = ""
            employer?.text = ""
            
            // Display the image
            mainImageView!.downloaded(from: mainImageView!.getURL(path: item.mainImageURL))
            mainImageView!.layer.cornerRadius = 26
            mainImageView!.clipsToBounds = true
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
        LikeInfoUtil.storeLatestLikeYouInfo(
            LikeYouInfo(
                user_id,
                latest_liked_user_name: name,
                entity_id: castItem.id,
                image_url: castItem.mainImageURL
            )
        )
    }
    
}
