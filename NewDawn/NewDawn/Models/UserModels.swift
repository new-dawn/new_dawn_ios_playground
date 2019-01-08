//
//  File.swift
//  NewDawn
//
//  Created by 汤子毅 on 2019/1/7.
//  Copyright © 2019 New Dawn. All rights reserved.
//

import Foundation

// TODO: Move all user info constants to this file
let QUESTION = "question"
let ANSWER = "question_answer"
let ID = "id"

// This is a sample json dict we expect to receive from backend
let USER_DUMMY_DATA: NSDictionary = [
    "firstname": "Test",
    "lastname": "User",
    "degree": "Undergrad",
    "school": "NYU",
    "question_answers": [
        [
            "id": 1,
            "question": "How are you",
            "answer": "I'm fine"
        ],
        [
            "id": 2,
            "question": "How old are you",
            "answer": "I'm 22"
        ]
    ]
]

// Question and answer structures
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

// A user profile class instantiated by json dictionary sent from backend
class UserProfile {
    var firstname: String = UNKNOWN
    var lastname: String = UNKNOWN
    var height: Int = -1
    var hometown: String = UNKNOWN
    var school: String = UNKNOWN
    var degree: String = UNKNOWN
    var smoke: String = UNKNOWN
    var questionAnswers: Array<QuestionAnswer> = [QuestionAnswer]()
    
    init(data: NSDictionary) {
        if let firstname = data[FIRSTNAME] as? String {
            self.firstname = firstname
        }
        if let lastname = data[LASTNAME] as? String {
            self.lastname = lastname
        }
        if let height = data[HEIGHT] as? Int {
            self.height = height
        }
        if let hometown = data[HOMETOWN] as? String {
            self.lastname = hometown
        }
        if let school = data[SCHOOL] as? String {
            self.school = school
        }
        if let degree = data[DEGREE] as? String {
            self.degree = degree
        }
        if let smoke = data[SMOKE] as? String {
            self.smoke = smoke
        }
        if let question_answers = data[QUESTION_ANSWERS] as? Array<NSDictionary> {
            for dict in question_answers {
                if let id = dict[ID] as? Int, let question = dict[QUESTION] as? String, let answer = dict[ANSWER] as? String {
                    questionAnswers.append(
                        QuestionAnswer(question: Question(id: id, question: question), answer: answer))
                }
            }
        }
    }
}
