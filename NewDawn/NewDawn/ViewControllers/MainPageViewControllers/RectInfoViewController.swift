//
//  RectInfoViewController.swift
//  NewDawn
//
//  Created by 汤子毅 on 2019/5/12.
//  Copyright © 2019 New Dawn. All rights reserved.
//

import UIKit

class RectInfoViewController: UIViewController {
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var yourImageView: UIImageView!
    @IBOutlet weak var yourCommentTextView: UITextView!
    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var myAnswerTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Get my profile photo and firstname
        LoginUserUtil.fetchLoginUserProfile() {
            user_profile, error in
            if error != nil {
                DispatchQueue.main.async {
                    self.displayMessage(userMessage: "Error: Fetch Login User Profile Failed: \(error!)")
                }
                return
            }
            if let my_image_url = user_profile?.mainImages.first?.image_url {
                self.myImageView.downloaded(
                    from: self.myImageView.getURL(path: my_image_url))
                ImageUtil.polishCircularImageView(imageView: self.myImageView)
            }
            if let my_first_name = user_profile?.firstname {
                let like_me_info = LikeInfoUtil.getLatestLikeMeInfo()
                DispatchQueue.main.async {
                    if let my_question = like_me_info?.likedInfo.liked_question {
                        self.questionTextView.text = my_question
                    }
                    if let my_answer = like_me_info?.likedInfo.liked_answer {
                        self.myAnswerTextView.text = "\(my_first_name): \(my_answer)"
                    }
                }
            }
        }
        // Get your image and comment
        let like_me_info = LikeInfoUtil.getLatestLikeMeInfo()
        if let your_image_url = like_me_info?.yourImageURL {
             yourImageView.downloaded(from: yourImageView.getURL(path: your_image_url))
             ImageUtil.polishCircularImageView(imageView: self.yourImageView)
        }
        if let your_comment = like_me_info?.likedInfo.liked_message, let your_first_name = like_me_info?.yourFirstName {
            yourCommentTextView.text = "\(your_first_name): \(your_comment)"
        }
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
}
