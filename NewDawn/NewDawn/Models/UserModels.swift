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
let IMAGE_URL = "image_url"
let AGE = "age"
let CANDIDATE_PROFILES = "user_profiles"
let USERID = "user_id"
let LIKED_INFO_FROM_YOU = "liked_info_from_you"
let LIKED_INFO_FROM_ME = "liked_info_from_me"
let LIKED_MESSAGE = "liked_message"
let LIKED_ENTITY_TYPE = "liked_entity_type"
let LIKED_IMAGE_URL = "liked_image_url"
let LIKED_QUESTION = "liked_question"
let LIKED_ANSWER = "liked_answer"

// This is a sample json dict we expect to receive from backend
let USER_DUMMY_DATA_1: NSDictionary = [
    "first_name": "Teddy",
    "user_id": "2",
    "last_name": "C",
    "age": 18,
    "degree": "Undergrad",
    "height": 175,
    "school": "NYU",
    "smoke": "socially",
    "drink": "a little",
    "hometown": "Beijing",
    "job_title": "Designer",
    "employer": "Chanel",
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
    "first_name": "Ziyi",
    "last_name": "Tang",
    "user_id": "3",
    "age": 28,
    "degree": "Undergrad",
    "height": 120,
    "school": "NYU",
    "smoke": "never",
    "drink": "a lot",
    "hometown": "Shenzhen",
    "job_title": "Software Engineer",
    "employer": "Instagram",
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
    var id: Int
    var question: Question
    var answer: String
    init() {
        self.id = 0
        self.question = Question()
        self.answer = UNKNOWN
    }
    init(id: Int, question: Question, answer: String) {
        self.id = id
        self.question = question
        self.answer = answer
    }
}

struct MainImage: Codable {
    var id: Int
    var image_url: String
    var caption: String
    init(id: Int, image_url: String, caption: String) {
        self.id = id
        self.image_url = image_url
        self.caption = caption
    }
}

// A user profile class instantiated by json dictionary sent from backend
struct UserProfile: Codable {
    var user_id: String = UNKNOWN
    var firstname: String = UNKNOWN
    var lastname: String = UNKNOWN
    var age: Int = -1
    var height: Int = -1
    var hometown: String = UNKNOWN
    var school: String = UNKNOWN
    var degree: String = UNKNOWN
    var drink: String = UNKNOWN
    var jobTitle: String = UNKNOWN
    var employer: String = UNKNOWN
    var smoke: String = UNKNOWN
    var questionAnswers: Array<QuestionAnswer> = [QuestionAnswer]()
    var mainImages: Array<MainImage> = [MainImage]()
    var likedInfoFromYou: LikedInfo = LikedInfo([:])
    var likedInfoFromMe: LikedInfo = LikedInfo([:])
    
    init(data: NSDictionary) {
        if let user_id = data[USERID] as? String {
            self.user_id = user_id
        }
        if let firstname = data[FIRSTNAME] as? String {
            self.firstname = firstname
        }
        if let lastname = data[LASTNAME] as? String {
            self.lastname = lastname
        }
        if let age = data[AGE] as? Int {
            self.age = age
        }
        if let height = data[HEIGHT] as? Int {
            self.height = height
        }
        if let hometown = data[HOMETOWN] as? String {
            self.hometown = hometown
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
        if let jobTitle = data[JOBTITLE] as? String {
            self.jobTitle = jobTitle
        }
        if let employer = data[WORKPLACE] as? String {
            self.employer = employer
        }
        if let question_answers = data[QUESTION_ANSWERS] as? Array<NSDictionary> {
            for dict in question_answers {
                if let id = dict[ID] as? Int,
                    let question_dict = dict[QUESTION] as? NSDictionary,
                    let question = question_dict[QUESTION] as? String,
                    let question_id = question_dict[ID] as? Int,
                    let answer = dict[ANSWER] as? String {
                    questionAnswers.append(
                        QuestionAnswer(id: id, question: Question(id: question_id, question: question), answer: answer))
                }
            }
        }
        if let images = data[IMAGES] as? Array<NSDictionary> {
            for dict in images {
                if let image_url = dict[MEDIA] as? String, let caption = dict[CAPTION] as? String, let id = dict[ID] as? Int {
                    mainImages.append(
                        MainImage(id: id, image_url: image_url, caption: caption))
                }
            }
        }
        if let likedInfoFromYou = data[LIKED_INFO_FROM_YOU] as? [String:Any] {
            self.likedInfoFromYou = LikedInfo(likedInfoFromYou)
        }
        if let likedInfoFromMe = data[LIKED_INFO_FROM_ME] as? [String:Any] {
            self.likedInfoFromMe = LikedInfo(likedInfoFromMe)
        }
    }
}


class UserProfileBuilder{
    
    static func createGetProfileRequest(_ input_params: [String:String] = [:])-> URLRequest?{
        let params = HttpUtil.encodeParams(raw_params: input_params)
        let url = HttpUtil.getURL(path: "/profile/" + params)
        var request = URLRequest(url:url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("ApiKey", forHTTPHeaderField: "Authorization")
        return request
    }
    
    // Usage for user to other users' profiles information from backend
    static func fetchUserProfiles(params: [String:String] = [:], callback: @escaping (NSDictionary, String?) -> Void){
        // TODO: get username and api_key from keychain/local storage
        let request = UserProfileBuilder.createGetProfileRequest(params)
        HttpUtil.processSessionTasks(request: request!, callback: callback)
    }
    
    static func parseProfileInfo(profile_data: [String: Any]) -> NSDictionary {
        let user_data = profile_data["user"] as? NSDictionary
        let user_id_int = user_data?["id"] as? Int ?? -1
        let info: NSMutableDictionary = [
            USERID: String(user_id_int),
            FIRSTNAME: user_data?[FIRSTNAME] as? String ?? UNKNOWN,
            LASTNAME: user_data?[LASTNAME] as? String ?? UNKNOWN,
            AGE: profile_data[AGE] as? Int ?? UNKNOWN,
            HEIGHT: profile_data[HEIGHT] as? Int ?? UNKNOWN,
            HOMETOWN: profile_data[HOMETOWN] as? String ?? UNKNOWN,
            WORKPLACE: profile_data[WORKPLACE] as? String ?? UNKNOWN,
            JOBTITLE: profile_data[JOBTITLE] as? String ?? UNKNOWN,
            DEGREE: profile_data[DEGREE] as? String ?? UNKNOWN,
            SCHOOL: profile_data[SCHOOL] as? String ?? UNKNOWN,
            SMOKE: profile_data[SMOKE] as? String ?? UNKNOWN,
            DRINK: profile_data[DRINK] as? String ?? UNKNOWN,
            IMAGES: profile_data[IMAGES] as? Array<NSDictionary> ?? Array<NSDictionary>(),
            QUESTION_ANSWERS: profile_data[QUESTION_ANSWERS] as? Array<NSDictionary> ?? Array<NSDictionary>(),
            LIKED_INFO_FROM_YOU: profile_data[LIKED_INFO_FROM_YOU] as? [String:Any] ?? [:],
            LIKED_INFO_FROM_ME: profile_data[LIKED_INFO_FROM_ME] as? [String:Any] ?? [:]
        ]
        return info
    }
    
    static func parseAndReturn(response: NSDictionary)-> [UserProfile] {
        var fetched_users = [UserProfile]()
        if let profile_responses = response["objects"] as? [[String: Any]] {
            for profile in profile_responses {
                let dummy_user = UserProfileBuilder.parseProfileInfo(profile_data: profile)
                let dummy_user_profile = UserProfile(data: dummy_user as NSDictionary)
                fetched_users.append(dummy_user_profile)
            }
        }
        return fetched_users
    }
    
    // Store all retrieved users' information to a list of dictionary and into local storage
    static func parseAndStoreInLocalStorage(response: NSDictionary)-> Void{
        var fetched_users = [UserProfile]()
        if let profile_responses = response["objects"] as? [[String: Any]] {
            for profile in profile_responses {
                let dummy_user = UserProfileBuilder.parseProfileInfo(profile_data: profile)
                let dummy_user_profile = UserProfile(data: dummy_user as NSDictionary)
                fetched_users.append(dummy_user_profile)
            }
            LocalStorageUtil.localStoreKeyValueStruct(key: CANDIDATE_PROFILES, value: fetched_users)
        }
    }
    
    
    static func getUserProfileListFromLocalStorage()->[UserProfile]{
        let profilesData: [UserProfile]? = LocalStorageUtil.localReadKeyValueStruct(key: CANDIDATE_PROFILES)
        if profilesData == nil{
            return [UserProfile]()
        }else{
            return profilesData!
        }
    }
}
