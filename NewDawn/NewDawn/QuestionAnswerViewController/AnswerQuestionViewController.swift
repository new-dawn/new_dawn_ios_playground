//
//  AnswerQuestionViewController.swift
//  NewDawn
//
//  Created by 汤子毅 on 2018/12/28.
//  Copyright © 2018 New Dawn. All rights reserved.
//

import UIKit

class AnswerQuestionViewController: UIViewController {
    
    let QUESTION_ANSWERS = "question_answers"
    
    // The question to be selected from previous view
    var question = Question()

    @IBOutlet weak var questionTextField: UITextView!
    @IBOutlet weak var answerTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        polishTextView(textView: questionTextField, text: question.question)
        polishTextView(textView: answerTextField)
    }
    
    func createQuestionAnswer() -> QuestionAnswer {
        return QuestionAnswer(q_id: question.id, answer: answerTextField.text!)
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        if (answerTextField.text?.isEmpty)! {
            displayMessage(userMessage: "Answer cannot be empty")
        }
    }

}
