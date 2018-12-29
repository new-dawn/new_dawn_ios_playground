//
//  AnswerQuestionViewController.swift
//  NewDawn
//
//  Created by 汤子毅 on 2018/12/28.
//  Copyright © 2018 New Dawn. All rights reserved.
//

import UIKit

class AnswerQuestionViewController: UIViewController {
    
    // The question to be selected from previous view
    var question = Question()

    @IBOutlet weak var questionTextField: UITextView!
    @IBOutlet weak var answerTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        polishTextView(textView: questionTextField, text: question.question)
        polishTextView(textView: answerTextField)
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
    }

}
