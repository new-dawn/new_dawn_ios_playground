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
    }

    @IBAction func likeButtonTapped(_ sender: Any) {
        ProfileIndexUtil.updateProfileIndex()
        dismiss(animated: true)
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
