//
//  QuestionViewController.swift
//  NewDawn
//
//  Created by 汤子毅 on 2018/12/27.
//  Copyright © 2018 New Dawn. All rights reserved.
//

import UIKit

struct Question {
    var id: Int
    var question: String
    init(id: Int, question: String) {
        self.id = id
        self.question = question
    }
}

struct QuestionAnswer {
    var q_id: Int
    var answer: String
    init(q_id: Int, answer: String) {
        self.q_id = q_id
        self.answer = answer
    }
}

class QuestionViewController: UIViewController {
    
    @IBOutlet weak var selectQuestionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        polishUIButton(button: selectQuestionButton)
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
