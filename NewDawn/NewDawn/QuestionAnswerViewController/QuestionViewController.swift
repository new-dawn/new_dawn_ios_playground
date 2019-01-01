//
//  QuestionViewController.swift
//  NewDawn
//
//  Created by 汤子毅 on 2018/12/27.
//  Copyright © 2018 New Dawn. All rights reserved.
//

import UIKit

let UNKNOWN = "N/A"

struct Question: Codable {
    var id: Int
    var question: String
    init() {
        self.id = 0
        self.question = UNKNOWN
    }
    init(id: Int, question: String) {
        self.id = id
        self.question = question
    }
}

struct QuestionAnswer: Codable {
    var question: Question
    var answer: String
    init() {
        self.question = Question()
        self.answer = UNKNOWN
    }
    init(question: Question, answer: String) {
        self.question = question
        self.answer = answer
    }
}

class QuestionViewController: UIViewController {
    
    let QUESTION_WIDTH = 257
    let QUESTION_HEIGHT = 40
    let QUESTION_BLOCK_HEIGHT = 50
    let Y_CENTER_OFFSET = 85
    let QUESTION_FONT_SIZE = 12
    
    var questionAnswers = [QuestionAnswer]()

    @IBOutlet weak var selectQuestionButton: UIButton!
    
    func getQuestionAnswersFromLocalStore() -> Array<QuestionAnswer> {
        if let data = UserDefaults.standard.value(forKey: QUESTION_ANSWERS) as? Data {
            let question_answers_existed = try? PropertyListDecoder().decode(Array<QuestionAnswer>.self, from: data)
            if (question_answers_existed != nil) {
                return question_answers_existed!
            }
        }
        return [QuestionAnswer]()
    }
    
    func createQuestionAnswerButton(question_answer: QuestionAnswer, offsetY: Int) -> UIButton {
        let questionButton = UIButton(
            frame: genCenterRect(width: QUESTION_WIDTH, height: QUESTION_HEIGHT, offsetY: offsetY))
        // Set button style and content
        polishQuestionButton(button: questionButton)
        questionButton.setTitle(question_answer.question.question, for: .normal)
        questionButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        // Store question if as button tag
        questionButton.tag = Int(question_answer.question.id)

        // Add the button to the container
        return questionButton
    }
    
    func generateQuestionAnswers(question_answers: Array<QuestionAnswer>) -> Void {
        // A dynamic offset to control the distance
        // between question blocks
        var buttonOffsetY: Int = Y_CENTER_OFFSET
        for question_answer in question_answers {
            // Auto-generate a question button
            // Increment the offset for next button
            let questionButton = createQuestionAnswerButton(question_answer: question_answer, offsetY: buttonOffsetY)
            buttonOffsetY = buttonOffsetY + QUESTION_BLOCK_HEIGHT
            view.addSubview(questionButton)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        polishUIButton(button: selectQuestionButton)
        let question_answers = getQuestionAnswersFromLocalStore()
        generateQuestionAnswers(question_answers: question_answers)
    }
    
    // Hide navigation bar for this specific view
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // Restore navigation bar for following views
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
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
