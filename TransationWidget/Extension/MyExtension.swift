//
//  MyExtension.swift
//  TransationWidget
//
//  Created by Pheayuit.Yen    on 3/2/25.
//

import Foundation


class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    
    static let appName : String = {
        #if DEBUG
            return "group.com.TransationWidget"
        #else
            /// RELEASE / PRODUCTION
            return ""
        #endif
    }()
    
    private let userDefaults = UserDefaults(suiteName: appName)
    
    // Example: Store a string value
    func setStringValue(_ value: String, forKey key: String) {
        userDefaults?.set(value, forKey: key)
    }
    
    func stringValue(forKey key: String) -> String? {
        return userDefaults?.string(forKey: key)
    }
    
    // Example: Store an integer value
    func setIntegerValue(_ value: Int, forKey key: String) {
        userDefaults?.set(value, forKey: key)
    }
    
    func integerValue(forKey key: String) -> Int? {
        return userDefaults?.integer(forKey: key)
    }
    
    func doubleValue(_ value: Double, forKey key: String) {
        userDefaults?.set(value, forKey: key)
    }
    
    // Add more methods for other data types as needed
}

extension Notification.Name {
    static let reloadWidget = Notification.Name("reloadWidget")
}
