//
//  LocalStorageUtil.swift
//  NewDawn
//
//  Created by 汤子毅 on 2019/1/16.
//  Copyright © 2019 New Dawn. All rights reserved.
//

import Foundation

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
}
