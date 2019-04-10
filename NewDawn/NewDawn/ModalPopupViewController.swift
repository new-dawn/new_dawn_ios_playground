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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Make keyboard show/hide dynamically moves the view
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        if let name = getLikedUserName() {
            titleLabel?.text = name
        }
    }

    @IBAction func likeButtonTapped(_ sender: Any) {
        let lastest_liked_item = getLikedItem() as! [String: Any]
        let lastest_liked_user_id = getLikedUserID()!
        let local_user_id = String(LoginUserUtil.getLoginUserId()!)
        HttpUtil.sendAction(user_from: local_user_id,
                            user_to: lastest_liked_user_id,
                            action_type: UserActionType.LIKE.rawValue,
                            entity_type: lastest_liked_item[ENTITY_TYPE] as! Int,
                            entity_id: lastest_liked_item[ENTITY_ID] as! Int,
                            message: commentTextField.text)
        dismiss(animated: true)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "likeButtonTappedOnPopupModal"), object: nil)
    }
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    func getKeyboardOffsetFactor() -> CGFloat {
        return 0
    }
    
    func getLikedItem() -> Optional<Any> {
        return LocalStorageUtil.localReadKeyValue(key: LATEST_LIKED_ITEM)
    }
    
    func getLikedUserName() -> String? {
        return LocalStorageUtil.localReadKeyValue(key: LATEST_LIKED_USER_NAME) as? String
    }
    
    func getLikedUserID() -> String? {
        return LocalStorageUtil.localReadKeyValue(key: LATEST_LIKED_USER_ID) as? String
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
        if let image = getLikedItem() as? NSDictionary {
            imageView!.downloaded(from: imageView!.getURL(path: image[IMAGE_URL] as! String))
        }
        imageView.clipsToBounds = true
    }
    
    override func getKeyboardOffsetFactor() -> CGFloat {
        return 2
    }
}

class ModalQuestionAnswerLikedViewController: ModalPopupViewController {
    
    @IBOutlet weak var questionText: UITextView!
    @IBOutlet weak var questionAnswerText: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let questionAnswer = getLikedItem() as? NSDictionary {
            questionText?.text = questionAnswer[QUESTION] as? String
            questionAnswerText?.text = questionAnswer[ANSWER] as? String
        }
    }

    override func getKeyboardOffsetFactor() -> CGFloat {
        return 2
    }
}
