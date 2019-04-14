//
//  ProfileIndexUtil.swift
//  NewDawn
//
//  Created by 汤子毅 on 2019/1/16.
//  Copyright © 2019 New Dawn. All rights reserved.
//

import Foundation

let MAIN_PAGE_PROFILE_INDEX = "main_page_profile_index"

class ProfileIndexUtil {
    static func loadProfileIndex() -> Int {
        if let index = LocalStorageUtil.localReadKeyValue(key: MAIN_PAGE_PROFILE_INDEX) as? Int {
            return index
        }
        LocalStorageUtil.localStoreKeyValue(key: MAIN_PAGE_PROFILE_INDEX, value: 0)
        return 0
    }
    
    static func reachLastProfile(profiles: Array<UserProfile>) -> Bool {
        return loadProfileIndex() == profiles.count - 1
    }
    
    static func updateProfileIndex() -> Void {
        LocalStorageUtil.localStoreKeyValue(key: MAIN_PAGE_PROFILE_INDEX, value: loadProfileIndex() + 1)
    }
    
    static func refreshProfileIndex() -> Void {
        LocalStorageUtil.localStoreKeyValue(key: MAIN_PAGE_PROFILE_INDEX, value: 0)
    }
    
    static func noMoreProfile(profiles: Array<UserProfile>) -> Bool {
        return loadProfileIndex() >= profiles.count
    }
}
