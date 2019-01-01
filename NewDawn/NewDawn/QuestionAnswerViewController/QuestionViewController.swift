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
    var q_id: Int
    var answer: String
    init() {
        self.q_id = 0
        self.answer = UNKNOWN
    }
    init(q_id: Int, answer: String) {
        self.q_id = q_id
        self.answer = answer
    }
}

class QuestionViewController: UIViewController {
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        polishUIButton(button: selectQuestionButton)
        let question_answers = getQuestionAnswersFromLocalStore()
        self.displayMessage(userMessage: "Number of answers: \(question_answers.count)")
        for question_answer in question_answers {
            
        }
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
