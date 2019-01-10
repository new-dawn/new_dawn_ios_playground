//
//  QuestionViewController.swift
//  NewDawn
//
//  Created by 汤子毅 on 2018/12/27.
//  Copyright © 2018 New Dawn. All rights reserved.
//

import UIKit

let UNKNOWN = "N/A"

class QuestionViewController: UIViewController {
    
    let QUESTION_WIDTH = 257
    let QUESTION_HEIGHT = 40
    let QUESTION_BLOCK_HEIGHT = 50
    let Y_CENTER_OFFSET = 50
    let QUESTION_FONT_SIZE = 12
    let QUESTION_MAX_NUM = 3
    
    let SELECT_QUESTION_TEXT = "Select a question                     +"
    
    // Keep track of all question answer views
    var questionAnswerViews = [UIView]()
    
    func getQuestionAnswersFromLocalStore() -> Array<QuestionAnswer> {
        if let existed_question_answers: Array<QuestionAnswer> = localReadKeyValueStruct(key: QUESTION_ANSWERS) {
            return existed_question_answers
        }
        return [QuestionAnswer]()
    }
    
    func removeQuestionAnswerFromLocalStore(q_id: Int) -> Void {
        // Remove the answered question from local storage
        if var existed_question_answers: Array<QuestionAnswer> = localReadKeyValueStruct(key: QUESTION_ANSWERS) {
            var index = -1
            for question_answer in existed_question_answers {
                index = index + 1
                if question_answer.question.id == q_id {
                    break
                }
            }
            if index != -1 {
                existed_question_answers.remove(at: index)
            }
            localStoreKeyValueStruct(key: QUESTION_ANSWERS, value: existed_question_answers)
        }
    }
    
    @objc func crossSignButtonClicked(sender: UIButton) {
        removeQuestionAnswerFromLocalStore(q_id: sender.tag)
        let question_answers = getQuestionAnswersFromLocalStore()
        refreshQuestionAnswers(refreshed_question_answers: question_answers)
    }
    
    @objc func selectQuestionButtonClicked(sender: UIButton) {
        // Find the correct question by taking the button tag
        performSegue(withIdentifier: "selectQuestion", sender: "selectQuestionButton")
    }
    
    func createCrossSignButton(question_answer: QuestionAnswer) -> UIButton {
        // A cross sign button on the right top corner of each button
        let crossButton = UIButton(frame: CGRect(x: QUESTION_WIDTH-QUESTION_HEIGHT, y: QUESTION_HEIGHT/2-(QUESTION_HEIGHT/2), width: QUESTION_HEIGHT, height: QUESTION_HEIGHT))
        crossButton.layer.cornerRadius = CGFloat(QUESTION_HEIGHT/2)
        crossButton.backgroundColor = UIColor.gray
        //crossButton.setImage(UIImage(named: "cross.png"), for: .normal)
        crossButton.setTitle("x", for: .normal)
        crossButton.addTarget(self, action: #selector(crossSignButtonClicked), for: .touchUpInside)
        crossButton.autoresizingMask = [.flexibleLeftMargin, .flexibleBottomMargin]
        crossButton.tag = Int(question_answer.question.id)
        return crossButton
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

        // Add cross sign button
        let crossSignButton = createCrossSignButton(question_answer: question_answer)
        questionButton.addSubview(crossSignButton)
        return questionButton
    }
    
    func createSelectQuestionButton(offsetY: Int) -> UIButton {
        let selectQuestionButton = UIButton(
            frame: genCenterRect(width: QUESTION_WIDTH, height: QUESTION_HEIGHT, offsetY: offsetY))
        // Set button style and content
        polishQuestionButton(button: selectQuestionButton)
        selectQuestionButton.setTitle(SELECT_QUESTION_TEXT, for: .normal)
        selectQuestionButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        selectQuestionButton.addTarget(self, action:#selector(self.selectQuestionButtonClicked), for: .touchUpInside)
        
        // Add the button to the container
        return selectQuestionButton
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
            questionAnswerViews.append(questionButton)
        }
        if question_answers.count < QUESTION_MAX_NUM {
            // Append select question button at the end
            // if the number of questions is below threshold
            let selectQuestionButton = createSelectQuestionButton(offsetY: buttonOffsetY)
            view.addSubview(selectQuestionButton)
            questionAnswerViews.append(selectQuestionButton)
        }
    }
    
    func refreshQuestionAnswers(refreshed_question_answers: Array<QuestionAnswer>) -> Void {
        for questionAnswerView in questionAnswerViews {
            questionAnswerView.removeFromSuperview()
        }
        questionAnswerViews.removeAll()
        generateQuestionAnswers(question_answers: refreshed_question_answers)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
