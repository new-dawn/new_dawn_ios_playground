//
//  QuestionViewController.swift
//  NewDawn
//
//  Created by 汤子毅 on 2018/12/27.
//  Copyright © 2018 New Dawn. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController {
    // TODO: Replace hardcoded questions with backend request
    var sample_questions = [
        "Do you like hiking?",
        "What's your favorate song?",
        "Do you have a pet?"
    ]
    @IBOutlet weak var selectQuestionButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        polishUIButton(button: selectQuestionButton)
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
