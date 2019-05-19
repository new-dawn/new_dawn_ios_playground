//
//  LocalStorageUtil.swift
//  NewDawn
//
//  Created by 汤子毅 on 2019/1/16.
//  Copyright © 2019 New Dawn. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper
import UIKit

class LocalStorageUtil {
    // A helper function to store key value pair locally
    static func localStoreKeyValue(key: String, value: Any) -> Void {
        let userDefaults = UserDefaults.standard
        userDefaults.set(value, forKey: key)
        userDefaults.synchronize()
    }
    
    // A helper function to store key value pair locally
    // with value being a codable strct
    static func localStoreKeyValueStruct<T: Codable>(key: String, value: T) -> Void {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(value), forKey: key)
    }
    
    // A helper function to get key value pair locally
    static func localReadKeyValue(key: String) -> Any? {
        return UserDefaults.standard.object(forKey: key)
    }
    
    // A helper function to get key value pair locally
    // with value being a codable struct
    static func localReadKeyValueStruct<T: Codable>(key: String) -> T? {
        if let data = UserDefaults.standard.value(forKey: key) as? Data {
            let value = try? PropertyListDecoder().decode(T.self, from: data)
            return value
        }
        return nil
    }
    
    static func localRemoveKey(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
}

class LoginUserUtil {

    static let ACCESS_TOKEN = "accessToken"
    static let USER_ID = "user_id"
    static let LOGIN_USER_PROFILE = "login_user_profile"

    static func getLoginUserId() -> String? {
        return KeychainWrapper.standard.string(forKey: LoginUserUtil.USER_ID)
    }
    
    static func saveLoginUserId(user_id: String) -> Bool {
        return KeychainWrapper.standard.set(user_id, forKey: LoginUserUtil.USER_ID)
    }
    
    static func getAccessToken() -> String? {
        return KeychainWrapper.standard.string(forKey: LoginUserUtil.ACCESS_TOKEN)
    }
    
    static func saveAccessToken(token: String) -> Bool {
        return KeychainWrapper.standard.set(token, forKey: LoginUserUtil.ACCESS_TOKEN)
    }
    
    static func isLogin() -> Bool {
        return KeychainWrapper.standard.hasValue(forKey: LoginUserUtil.USER_ID)
    }
    
    static func logout() -> Bool {
        LocalStorageUtil.localRemoveKey(key: LoginUserUtil.LOGIN_USER_PROFILE)
        return KeychainWrapper.standard.removeAllKeys()
    }

    static func fetchUserProfile(user_id: String, accessToken: String, callback: @escaping (UserProfile?, String?) -> Void) -> Void {
        // TODO: Send username and access token to get user profile
        UserProfileBuilder.fetchUserProfiles(params: ["user__username": String(user_id), "apikey": accessToken]) {
            (data, error) in
            let profiles = UserProfileBuilder.parseAndReturn(response: data)
            if !profiles.isEmpty {
                callback(profiles[0], error)
            } else {
                callback(nil, error)
            }
        }
    }
    
    static func fetchLoginUserProfile(_ refreshLocalStorage: Bool = false, callback: @escaping (UserProfile?, String?) -> Void) -> Void {
        // This is a lazy fetcher where user profile will only be fetched when needed
        // After fetching, the user profile is stored locally
        // Notice that user profile will be nil if user id and accessToken is not in keychain
        if let user_id = getLoginUserId(), let accessToken = getAccessToken() {
            // Check if the user profile has already fetched and stored in local storage
            if refreshLocalStorage == false, let user_profile: UserProfile? = LocalStorageUtil.localReadKeyValueStruct(key: LoginUserUtil.LOGIN_USER_PROFILE) {
                callback(user_profile, nil)
            } else {
                LoginUserUtil.fetchUserProfile(user_id: user_id, accessToken: accessToken) {
                    user_profile, error in
                    LocalStorageUtil.localStoreKeyValueStruct(key: LoginUserUtil.LOGIN_USER_PROFILE, value: user_profile)
                    callback(user_profile, error)
                }
            }
        } else {
            // There's no user id an access token found in local keychain
            LocalStorageUtil.localRemoveKey(key: LoginUserUtil.LOGIN_USER_PROFILE)
            callback(nil, "No keychain is found locally")
        }
    }
}
