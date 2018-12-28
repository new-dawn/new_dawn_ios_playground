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
    let Y_CENTER_OFFSET = -150

    // TODO: Replace hardcoded questions with backend request
    var sample_questions = [
        Question(id: 1, question: "Do you like hiking?"),
        Question(id: 2, question: "What's your favorate song?"),
        Question(id: 3, question: "Do you have a pet?"),
        Question(id: 4, question: "What's your best hobby?"),
        Question(id: 5, question: "What't your most recent trip?"),
    ]
    
    func getContentHeight() -> Int {
        return QUESTION_BLOCK_HEIGHT * sample_questions.count + 100
    }
    
    func generateQuestions() -> Void {
        // A dynamic offset to control the distance
        // between question blocks
        var buttonOffsetY: Int = Y_CENTER_OFFSET
        for question in sample_questions {
            // Auto-generate a question button
            let questionButton = UIButton(
                frame: genCenterRect(width: QUESTION_WIDTH, height: QUESTION_HEIGHT, offsetY: buttonOffsetY))
            // Increment the offset for next button
            buttonOffsetY = buttonOffsetY + QUESTION_BLOCK_HEIGHT
            // Set button style and content
            polishQuestionButton(button: questionButton)
            questionButton.setTitle(question.question, for: .normal)
            questionButton.tag = Int(question.id)
            // Add the button to the container
            containerView.addSubview(questionButton)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Create a scroll view
        self.scrollView = UIScrollView()
        self.scrollView.delegate = self
        self.scrollView.contentSize = CGSize(width: 0, height: getContentHeight())
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
