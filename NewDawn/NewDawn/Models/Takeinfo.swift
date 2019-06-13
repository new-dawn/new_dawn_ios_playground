//
//  Takeinfo.swift
//  NewDawn
//
//  Created by 周珈弘 on 6/12/19.
//  Copyright © 2019 New Dawn. All rights reserved.
//

import Foundation

struct TakeMeInfo: Codable {
    var yourImageURL: String = UNKNOWN
    var yourFirstName: String = UNKNOWN
    init(_ yourImageURL: String, yourFirstName: String) {
        self.yourImageURL = yourImageURL
        self.yourFirstName = yourFirstName
    }
}

struct TakeYouInfo: Codable {
    var image_url: String = UNKNOWN
    var latest_liked_user_id: String = UNKNOWN
    var latest_liked_user_name: String = UNKNOWN
    var my_id: Int = 0
    
    init(_ latest_liked_user_id: String, latest_liked_user_name: String) {
        self.latest_liked_user_id = latest_liked_user_id
        self.latest_liked_user_name = latest_liked_user_name
        self.my_id = LoginUserUtil.getLoginUserId() ?? 0
    }
    
    init(_ latest_liked_user_id: String, latest_liked_user_name: String, image_url: String) {
        self.latest_liked_user_id = latest_liked_user_id
        self.latest_liked_user_name = latest_liked_user_name
        self.image_url = image_url
        self.my_id = LoginUserUtil.getLoginUserId() ?? 0
    }
}
