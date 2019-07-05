//
//  ModalPopupViewController.swift
//  NewDawn
//
//  Created by 汤子毅 on 2019/1/24.
//  Copyright © 2019 New Dawn. All rights reserved.
//

import UIKit


class ModalPopupViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var commentTextField: UITextView!
    
    var triggeredSection: MainPageViewModelItemType?
    var latestLikeYouInfo: LikeYouInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Make keyboard show/hide dynamically moves the view
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.latestLikeYouInfo = LikeInfoUtil.getLatestLikeYouInfo()
        titleLabel?.text = self.latestLikeYouInfo?.latest_liked_user_name
        
    }

    @IBAction func likeButtonTapped(_ sender: Any) {
        if let latest_like_item = self.latestLikeYouInfo {
            HttpUtil.sendAction(
                user_from: String(latest_like_item.my_id),
                user_to: latest_like_item.latest_liked_user_id,
                action_type: UserActionType.LIKE.rawValue,
                entity_type: latest_like_item.entity_type,
                entity_id: latest_like_item.entity_id,
                message: commentTextField.text
            ) {
                success in
                if success{
                }
            }
        }
        dismiss(animated: true)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "likeButtonTappedOnPopupModal"), object: nil)
    }
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    func getKeyboardOffsetFactor() -> CGFloat {
        return 0
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height/self.getKeyboardOffsetFactor()
            }
        }
    }
    
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}

class ModalImageLikedViewController: ModalPopupViewController {
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let latest_liked_image_url = self.latestLikeYouInfo?.image_url {
            imageView!.downloaded(from: imageView!.getURL(path: latest_liked_image_url))
        }
        imageView.clipsToBounds = true
    }
    
    override func getKeyboardOffsetFactor() -> CGFloat {
        return 2.5
    }
}

class ModalQuestionAnswerLikedViewController: ModalPopupViewController {
    
    @IBOutlet weak var questionText: UITextView!
    @IBOutlet weak var questionAnswerText: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let latest_liked_q = self.latestLikeYouInfo?.question, let latest_liked_a = self.latestLikeYouInfo?.answer {
            questionText?.text = latest_liked_q
            questionAnswerText?.text = latest_liked_a
        }
    }

    override func getKeyboardOffsetFactor() -> CGFloat {
        return 2
    }
}
