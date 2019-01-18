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
    
    static func reachLastProfile() -> Bool {
        return loadProfileIndex() == USER_DUMMY_DATA.count - 1
    }
    
    static func updateProfileIndex() -> Void {
        LocalStorageUtil.localStoreKeyValue(key: MAIN_PAGE_PROFILE_INDEX, value: loadProfileIndex() + 1)
    }
    
    static func refreshProfileIndex() -> Void {
        LocalStorageUtil.localStoreKeyValue(key: MAIN_PAGE_PROFILE_INDEX, value: 0)
    }
}
