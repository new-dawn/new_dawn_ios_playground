//
//  AnswerQuestionViewController.swift
//  NewDawn
//
//  Created by 汤子毅 on 2018/12/28.
//  Copyright © 2018 New Dawn. All rights reserved.
//

import UIKit

let QUESTION_ANSWERS = "answer_questions"

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
    
    func createQuestionAnswer() -> QuestionAnswer {
        return QuestionAnswer(question: question, answer: answerTextField.text!)
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        if (answerTextField.text?.isEmpty)! {
            displayMessage(userMessage: "Answer cannot be empty")
        }
        let question_answer = QuestionAnswer(question: question, answer: answerTextField.text!)
        var question_answers = [QuestionAnswer]()
        // Check if local storage already has question answers
        if let existed_question_answers: Array<QuestionAnswer> = localReadKeyValueStruct(key: QUESTION_ANSWERS) {
            question_answers = existed_question_answers
        }
        // Append the new answer and store all question answers to local storage
        question_answers.append(question_answer)
        localStoreKeyValueStruct(key: QUESTION_ANSWERS, value: question_answers)
    }

}
