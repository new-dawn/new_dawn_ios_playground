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
    let QUESTION_HEIGHT = 90
    let QUESTION_BLOCK_HEIGHT = 95
    let Y_TOP_OFFSET = 20

    // TODO: Replace hardcoded questions with backend request
    var sample_questions = [
        Question(id: 1, question: "如果可以出演电影，我想演？"),
        Question(id: 2, question: "周末喜欢做什么?"),
        Question(id: 3, question: "我最喜欢的歌词是?"),
        Question(id: 4, question: "生命中影响我最深的人?"),
        Question(id: 5, question: "我的特别技能?"),
        Question(id: 6, question: "得到我的心的办法?"),
        Question(id: 7, question: "你会知道我喜欢你，如果？"),
        Question(id: 8, question: "Jason是不是最帅的?"),
    ]
    
    func getSampleQuestions() -> Array<Question> {
        return sample_questions
    }
    
    func isAnswered(question: Question) -> Bool {
        let answered_questions = self.getQuestionAnswersFromLocalStore()
        for answered_question in answered_questions {
            if answered_question.question.question == question.question {
                return true
            }
        }
        return false
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
    
    func createQuestionRect(offsetY: Int) -> CGRect {
        let screenSize: CGRect = UIScreen.main.bounds
        let questionRect = CGRect(
            x: (screenSize.width / 2) - CGFloat(QUESTION_WIDTH / 2),
            y: CGFloat(offsetY),
            width: CGFloat(QUESTION_WIDTH), height: CGFloat(QUESTION_HEIGHT))
        return questionRect
    }
    
    func createQuestionButton(question: Question, offsetY: Int) -> UIButton {
        let questionButton = UIButton(
            frame: createQuestionRect(offsetY: offsetY))
        // Set button style and content
        polishQuestionButton(button: questionButton)
        questionButton.setTitle(question.question, for: .normal)
        if isAnswered(question: question) {
            questionButton.setBackgroundImage(
                UIImage(named: "QuestionBlock2"), for: .normal)
            questionButton.isEnabled = false
        } else {
            questionButton.setBackgroundImage(
                UIImage(named: "QuestionBlock"), for: .normal)
            questionButton.titleEdgeInsets = UIEdgeInsets(top: -10.0, left: 0.0, bottom: 0.0, right: 0.0)
        }
        questionButton.layer.borderWidth = 0
        questionButton.titleLabel?.font =  UIFont(name: "PingFangTC-Regular", size: 16)
        // Store question if as button tag
        questionButton.tag = Int(question.id)
        questionButton.addTarget(self, action:#selector(self.buttonClicked), for: .touchUpInside)
        // Add the button to the container
        return questionButton
    }
    
    func generateQuestions() -> Void {
        // A dynamic offset to control the distance
        // between question blocks
        var buttonOffsetY: Int = Y_TOP_OFFSET
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
