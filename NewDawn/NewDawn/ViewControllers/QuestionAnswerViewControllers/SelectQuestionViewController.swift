//
//  SelectQuestionViewController.swift
//  NewDawn
//
//  Created by 汤子毅 on 2018/12/27.
//  Copyright © 2018 New Dawn. All rights reserved.
//

import UIKit

class SelectQuestionViewController: UIViewController, UIScrollViewDelegate {
    
    var scrollView: UIScrollView!
    var containerView = UIView()

    let QUESTION_WIDTH = 326
    let QUESTION_HEIGHT = 180
    let QUESTION_BLOCK_HEIGHT = 190
    let Y_CENTER_OFFSET = -200

    // TODO: Replace hardcoded questions with backend request
    var sample_questions = [
        Question(id: 1, question: "Do you like hiking?"),
        Question(id: 2, question: "What's your favorate song?"),
        Question(id: 3, question: "Do you have a pet?"),
        Question(id: 4, question: "What's your best hobby?"),
        Question(id: 5, question: "What't your most recent trip?"),
    ]
    
    func getSampleQuestions() -> Array<Question> {
        let answered_questions = self.getQuestionAnswersFromLocalStore()
        var unanswered_questions = [Question]()
        // Check if the sample question has already been answered
        for question in sample_questions {
            var already_answered = false
            for answered_question in answered_questions {
                if answered_question.question.question == question.question {
                    already_answered = true
                    break
                }
            }
            if already_answered == false {
                unanswered_questions.append(question)
            }
        }
        return unanswered_questions
    }
    
    func getQuestionAnswersFromLocalStore() -> Array<QuestionAnswer> {
        if let existed_question_answers: Array<QuestionAnswer> = localReadKeyValueStruct(key: QUESTION_ANSWERS) {
            return existed_question_answers
        }
        return [QuestionAnswer]()
    }
    
    func getQuestionByID(id: Int) -> Question {
        for question in self.getSampleQuestions() {
            if question.id == id {
                return question
            }
        }
        return self.getSampleQuestions()[0]
    }
    
    func getContentHeight() -> Int {
        return QUESTION_BLOCK_HEIGHT * self.getSampleQuestions().count + 100
    }
    
    @objc func buttonClicked(sender: UIButton) {
        // Find the correct question by taking the button tag
        let question = getQuestionByID(id: sender.tag)
        // Segue to the next view (Answer Question)
        performSegue(withIdentifier: "answerQuestion", sender: question)
    }
    
    func createQuestionButton(question: Question, offsetY: Int) -> UIButton {
        let questionButton = UIButton(
            frame: genCenterRect(width: QUESTION_WIDTH, height: QUESTION_HEIGHT, offsetY: offsetY))
        // Set button style and content
        polishQuestionButton(button: questionButton)
        questionButton.setTitle(question.question, for: .normal)
        // Store question if as button tag
        questionButton.tag = Int(question.id)
        questionButton.addTarget(self, action:#selector(self.buttonClicked), for: .touchUpInside)
        // Add the button to the container
        return questionButton
    }
    
    func generateQuestions() -> Void {
        // A dynamic offset to control the distance
        // between question blocks
        var buttonOffsetY: Int = Y_CENTER_OFFSET
        for question in self.getSampleQuestions() {
            // Auto-generate a question button
            // Increment the offset for next button
            let questionButton = createQuestionButton(question: question, offsetY: buttonOffsetY)
            buttonOffsetY = buttonOffsetY + QUESTION_BLOCK_HEIGHT
            containerView.addSubview(questionButton)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Create a scroll view
        self.scrollView = UIScrollView()
        self.scrollView.delegate = self
        self.scrollView.contentSize = CGSize(width: QUESTION_WIDTH, height: getContentHeight())
        // Create a container view
        containerView = UIView()
        scrollView.addSubview(containerView)
        view.addSubview(scrollView)
        // Create Questions
        generateQuestions()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        containerView.frame = CGRect(
            x: 0, y: 0,
            width: scrollView.contentSize.width,
            height: scrollView.contentSize.height)
    }

    // Prepare the question sent to Answer Question view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Push the selected Question to the next view
        let answerQuestionController = segue.destination as! AnswerQuestionViewController
        answerQuestionController.question = sender as! Question
    }

}
