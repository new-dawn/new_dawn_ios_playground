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
    
    static func localRemoveAll() {
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
    }
    
    static func cleanDirectory(directory: String){
        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(directory)
        guard let items = try? FileManager.default.contentsOfDirectory(atPath: path) else { return }
        
        for item in items {
            // This can be made better by using pathComponent
            let completePath = path.appending("/").appending(item)
            try? FileManager.default.removeItem(atPath: completePath)
        }
    }
    
    static func checkFolderExistOrCreate(dataPath: String){
        if !FileManager.default.fileExists(atPath: dataPath) {
            do {
                try FileManager.default.createDirectory(atPath: dataPath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Couldn't create document directory")
            }
        }
    }
}

class LoginUserUtil {

    static let ACCESS_TOKEN = "accessToken"
    static let USER_ID = "user_id"
    static let LOGIN_USER_PROFILE = "login_user_profile"

    static func getLoginUserId() -> Int? {
        return KeychainWrapper.standard.integer(forKey: LoginUserUtil.USER_ID)
    }
    
    static func saveLoginUserId(user_id: Int) -> Bool {
        return KeychainWrapper.standard.set(user_id, forKey: LoginUserUtil.USER_ID)
    }
    
    static func getAccessToken() -> String? {
        return KeychainWrapper.standard.string(forKey: LoginUserUtil.ACCESS_TOKEN)
    }
    
    static func saveAccessToken(token: String) -> Bool {
        return KeychainWrapper.standard.set(token, forKey: LoginUserUtil.ACCESS_TOKEN)
    }
    
    static func isLogin() -> Bool {
        return KeychainWrapper.standard.hasValue(forKey: LoginUserUtil.USER_ID) && KeychainWrapper.standard.hasValue(forKey: LoginUserUtil.ACCESS_TOKEN)
    }
    
    static func logout() -> Void {
        _ = KeychainWrapper.standard.removeAllKeys()
        LocalStorageUtil.localRemoveAll()
        // Take user to the landing page
        let landingStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        // Go to profile page
        DispatchQueue.main.async {
            let landingPage = landingStoryboard.instantiateViewController(withIdentifier: "AppLandingViewController")
                as! AppLandingViewController
            let appDelegate = UIApplication.shared.delegate
            appDelegate?.window??.rootViewController = landingPage
        }
    }

    static func fetchUserProfile(user_id: Int, accessToken: String, callback: @escaping (UserProfile?, String?) -> Void) -> Void {
        // TODO: Send username and access token to get user profile
        UserProfileBuilder.fetchUserProfiles(params: ["user__id": String(user_id), "apikey": accessToken]) {
            (data, error) in
            let profiles = UserProfileBuilder.parseAndReturn(response: data)
            if !profiles.isEmpty {
                callback(profiles[0], error)
            } else {
                callback(nil, error)
            }
        }
    }
    
    static func fetchLoginUserProfile(readLocal: Bool = true, callback: @escaping (UserProfile?, String?) -> Void) -> Void {
        // This is a lazy fetcher where user profile will only be fetched when needed
        // After fetching, the user profile is stored locally
        // Notice that user profile will be nil if user id and accessToken is not in keychain
        if let user_id = getLoginUserId(), let accessToken = getAccessToken() {
            // Check if the user profile has already fetched and stored in local storage
            if let user_profile: UserProfile? = LocalStorageUtil.localReadKeyValueStruct(key: LoginUserUtil.LOGIN_USER_PROFILE), readLocal == true {
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
    
    static func downloadOverwriteLocalInfo(profile: UserProfile){
        LocalStorageUtil.localStoreKeyValue(key: FIRSTNAME, value: profile.firstname)
        LocalStorageUtil.localStoreKeyValue(key: LASTNAME, value: profile.lastname)
        LocalStorageUtil.localStoreKeyValue(key: USERNAME, value: profile.username)
        LocalStorageUtil.localStoreKeyValue(key: HEIGHT, value: String(profile.height))
        LocalStorageUtil.localStoreKeyValue(key: AGE, value: String(profile.age))
        LocalStorageUtil.localStoreKeyValue(key: GENDER, value: String(profile.gender))
        LocalStorageUtil.localStoreKeyValue(key: BIRTHDAY, value: String(profile.birthday))
        LocalStorageUtil.localStoreKeyValue(key: HOMETOWN, value: profile.hometown)
        LocalStorageUtil.localStoreKeyValue(key: LOCATION, value: profile.location)
        LocalStorageUtil.localStoreKeyValue(key: SCHOOL, value: profile.school)
        LocalStorageUtil.localStoreKeyValue(key: DEGREE, value: profile.degree)
        LocalStorageUtil.localStoreKeyValue(key: JOBTITLE, value: profile.jobTitle)
        LocalStorageUtil.localStoreKeyValue(key: WORKPLACE, value: profile.employer)
        LocalStorageUtil.localStoreKeyValue(key: DRINK, value: profile.drink)
        LocalStorageUtil.localStoreKeyValue(key: SMOKE, value: profile.smoke)
        LocalStorageUtil.localStoreKeyValueStruct(key: QUESTION_ANSWERS, value: profile.questionAnswers)
    }
    
    static func downloadOverwriteLocalImages(profile: UserProfile){
        let dataPath = ImageUtil.getPersonalImagesDirectory()
        LocalStorageUtil.checkFolderExistOrCreate(dataPath: dataPath)
        LocalStorageUtil.cleanDirectory(directory: "PersonalImages")
        for (index, image) in profile.mainImages.enumerated(){
            let image_name = String(index)
            var fileURL = URL(fileURLWithPath:dataPath).appendingPathComponent(image_name)
            ImageUtil.downLoadImage(url: image.image_url){
                image in
                if let imageData = image.jpegData(compressionQuality: 1){
                    fileURL = fileURL.appendingPathExtension("jpeg")
                    do{
                        try imageData.write(to: fileURL, options: .atomic)
                    }catch{
                        print ("error", error)
                    }
                }
            }
        }
    }
    
}
