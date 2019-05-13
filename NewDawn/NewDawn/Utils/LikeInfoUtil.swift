//
//  LikeInfoUtil.swift
//  NewDawn
//
//  Created by 汤子毅 on 2019/5/12.
//  Copyright © 2019 New Dawn. All rights reserved.
//

import Foundation

class LikeInfoUtil {
    static let LATEST_LIKE_YOU_INFO = "latest_like_you_info"
    static let LATEST_LIKE_ME_INFO = "latest_like_me_info"
    static func getLatestLikeYouInfo() -> LikeYouInfo? {
        return LocalStorageUtil.localReadKeyValueStruct(key: LATEST_LIKE_YOU_INFO)
    }
    static func getLatestLikeMeInfo() -> LikeMeInfo? {
        return LocalStorageUtil.localReadKeyValueStruct(key: LATEST_LIKE_ME_INFO)
    }
    static func storeLatestLikeYouInfo(_ like_you_info: LikeYouInfo) -> Void {
        LocalStorageUtil.localStoreKeyValueStruct(key: LATEST_LIKE_YOU_INFO, value: like_you_info)
    }
    static func storeLatestLikeMeInfo(_ like_me_info: LikeMeInfo) -> Void {
        LocalStorageUtil.localStoreKeyValueStruct(key: LATEST_LIKE_ME_INFO, value: like_me_info)
    }
}
