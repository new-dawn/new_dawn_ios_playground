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
    "height": 175,
    "school": "NYU",
    "smoke": "socially",
    "drink": "a little",
    "hometown": "Beijing",
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
    "height": 120,
    "school": "NYU",
    "smoke": "never",
    "drink": "a lot",
    "hometown": "Shenzhen",
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
struct UserProfile: Codable {
    var firstname: String = UNKNOWN
    var lastname: String = UNKNOWN
    var height: Int = -1
    var hometown: String = UNKNOWN
    var school: String = UNKNOWN
    var degree: String = UNKNOWN
    var drink: String = UNKNOWN
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
            self.hometown = hometown
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
        if let drink = data[DRINK] as? String {
            self.drink = drink
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


class UserProfileBuilder{
    
    static func createGetProfileRequest(input_params: [String:String])-> URLRequest?{
        
        let params = HttpUtil.encodeParams(raw_params: input_params)
        let url = HttpUtil.getURL(path: "profile/" + params)
        var request = URLRequest(url:url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("ApiKey", forHTTPHeaderField: "Authorization")
        return request
    }
    
    // Usage for user to other users' profiles information from backend
    static func fetchAndStoreUserProfiles(callback: @escaping (NSDictionary) -> Void){
        // TODO: get username and api_key from keychain/local storage
        let psudo_params = [
            "username":"testadmin",
            "api_key":"617db2192d5f696b20f6309011a29e1be97aec29"
        ]
        let request = UserProfileBuilder.createGetProfileRequest(input_params: psudo_params)
        HttpUtil.processSessionTasks(request: request!, callback: callback)
    }
    
    static func parseProfileInfo(profile_data: [String: Any])-> [String: Any]{
        let user_data = profile_data["user"]! as? [String: Any]
        var info = [
            FIRSTNAME: user_data![FIRSTNAME]! as! String,
            LASTNAME: user_data![LASTNAME]! as! String,
            DEGREE: profile_data[DEGREE]! as! String,
            SCHOOL: profile_data[SCHOOL]! as! String,
            "images": [
                [
                    "media": "media/images/testcat.JPG",
                    "caption": "First image"
                ],
            ],
            "question_answers":[String]()
            ] as [String : Any]
        for answer_question in (profile_data["answer_question"] as? [[String: Any]])!{
            let answer_question_dict = [
                "id": answer_question["order"]!,
                QUESTION: answer_question[QUESTION]!,
                ANSWER: answer_question[ANSWER]!
                ] as [String : Any]
            var q_a_temp = info["question_answers"] as? [[String: Any]] ?? [[String: Any]]()
            q_a_temp.append(answer_question_dict)
            info["question_answers"] = q_a_temp
        }
        return info
    }
    
    // Store all retrieved users' information to a list of dictionary and into local storage
    static func parseAndStoreInLocalStorage(response: NSDictionary)-> Void{
        var fetched_users = [UserProfile]()
        let profile_responses = response["objects"] as? [[String: Any]]
        for profile in profile_responses!{
            let dummy_user = UserProfileBuilder.parseProfileInfo(profile_data: profile)
            let dummy_user_profile = UserProfile(data: dummy_user as NSDictionary)
            fetched_users.append(dummy_user_profile)
        }
        LocalStorageUtil.localStoreKeyValueStruct(key: "UserProfiles", value: fetched_users)
    }
    
    
    static func getUserProfileListFromLocalStorage()->[UserProfile]{
        let profilesData: [UserProfile]? = LocalStorageUtil.localReadKeyValueStruct(key: "UserProfiles")
        if profilesData == nil{
            return [UserProfile]()
        }else{
            return profilesData!
        }
    }
}
