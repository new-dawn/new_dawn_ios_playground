//
//  LikeInfo.swift
//  NewDawn
//
//  Created by 汤子毅 on 2019/5/12.
//  Copyright © 2019 New Dawn. All rights reserved.
//

import Foundation

struct LikedInfo: Codable {
    var liked_entity_type: Int = EntityType.NONE.rawValue
    var liked_image_url: String = UNKNOWN
    var liked_message: String = UNKNOWN
    var liked_question: String = UNKNOWN
    var liked_answer: String = UNKNOWN
    init() {}
    init(_ info: [String: Any]) {
        if let entity_type = info[LIKED_ENTITY_TYPE] as? Int {
            if entity_type == EntityType.MAIN_IMAGE.rawValue {
                liked_entity_type = EntityType.MAIN_IMAGE.rawValue
                liked_image_url = info[LIKED_IMAGE_URL] as? String ?? UNKNOWN
                liked_message = info[LIKED_MESSAGE] as? String ?? UNKNOWN
            }
            if entity_type == EntityType.QUESTION_ANSWER.rawValue {
                liked_entity_type = EntityType.QUESTION_ANSWER.rawValue
                liked_question = info[LIKED_QUESTION] as? String ?? UNKNOWN
                liked_answer = info[LIKED_ANSWER] as? String ?? UNKNOWN
                liked_message = info[LIKED_MESSAGE] as? String ?? UNKNOWN
            }
        }
    }
}

struct LikeMeInfo: Codable {
    var yourImageURL: String = UNKNOWN
    var myImageURL: String = UNKNOWN
    var likedInfo = LikedInfo()
    init(_ yourImageURL: String, myImageURL: String, likedInfo: LikedInfo) {
        self.yourImageURL = yourImageURL
        self.myImageURL = myImageURL
        self.likedInfo = likedInfo
    }
}

struct LikeYouInfo: Codable {
    var entity_id: Int = 0
    var entity_type: Int = 0
    var question: String = UNKNOWN
    var answer: String = UNKNOWN
    var image_url: String = UNKNOWN
    var latest_liked_user_id: String = UNKNOWN
    var latest_liked_user_name: String = UNKNOWN
    var my_id: Int = 0
    
    init(_ latest_liked_user_id: String, latest_liked_user_name: String, entity_id: Int, question: String, answer: String) {
        self.latest_liked_user_id = latest_liked_user_id
        self.latest_liked_user_name = latest_liked_user_name
        self.entity_id = entity_id
        self.entity_type = EntityType.QUESTION_ANSWER.rawValue
        self.question = question
        self.answer = answer
        self.my_id = LoginUserUtil.getLoginUserId() ?? 0
    }
    
    init(_ latest_liked_user_id: String, latest_liked_user_name: String, entity_id: Int, image_url: String) {
        self.latest_liked_user_id = latest_liked_user_id
        self.latest_liked_user_name = latest_liked_user_name
        self.entity_id = entity_id
        self.entity_type = EntityType.MAIN_IMAGE.rawValue
        self.image_url = image_url
        self.my_id = LoginUserUtil.getLoginUserId() ?? 0
    }
}
