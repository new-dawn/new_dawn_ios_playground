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
let ANSWER = "answer"
let ID = "id"
let IMAGES = "images"
let CAPTION = "caption"
let MEDIA = "media"

// This is a sample json dict we expect to receive from backend
let USER_DUMMY_DATA_1: NSDictionary = [
    "firstname": "Test",
    "lastname": "User",
    "degree": "Undergrad",
    "school": "NYU",
    "images": [
        [
            "media": "media/images/testcat.JPG",
            "caption": "First image"
        ],
    ],
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
        ],
        [
            "id": 3,
            "question": "What's your favorite sone",
            "answer": "Five Stars Red Flag"
        ],
    ]
]

let USER_DUMMY_DATA_2: NSDictionary = [
    "firstname": "Ziyi",
    "lastname": "Tang",
    "degree": "Undergrad",
    "school": "NYU",
    "images": [
        [
            "media": "media/images/testnyu.jpg",
            "caption": "First image"
        ],
    ],
    "question_answers": [
        [
            "id": 1,
            "question": "What's your favourate music",
            "answer": "GOGOGO"
        ],
        [
            "id": 2,
            "question": "Do you play games",
            "answer": "Yes"
        ],
        [
            "id": 3,
            "question": "What's your icon",
            "answer": "Five Stars"
        ],
    ]
]

let USER_DUMMY_DATA = [USER_DUMMY_DATA_1, USER_DUMMY_DATA_2]

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

struct MainImage: Codable {
    var image_url: String
    var caption: String
    init(image_url: String, caption: String) {
        self.image_url = image_url
        self.caption = caption
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
    var mainImages: Array<MainImage> = [MainImage]()
    
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
        if let images = data[IMAGES] as? Array<NSDictionary> {
            for dict in images {
                if let image_url = dict[MEDIA] as? String, let caption = dict[CAPTION] as? String {
                    mainImages.append(
                        MainImage(image_url: image_url, caption: caption))
                }
            }
        }
    }
}