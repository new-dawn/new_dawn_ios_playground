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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
}

class RectInfoQuestionAnswerViewController: RectInfoViewController {
    
    var question: String?
    var myImageURL: String?
    var myAnswer: String?
    var yourImageURL: String?
    var yourComment: String?
    
    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var myAnswerTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionTextView.text? = question ?? UNKNOWN
        myAnswerTextView.text? = myAnswer ?? UNKNOWN
        yourCommentTextView.text? = yourComment ?? UNKNOWN
        if (myImageURL != nil) {
            ImageUtil.downLoadImage(url: myImageURL!) {
                image in
                self.myImageView.image = image
            }
        }
    }
    
    
}
