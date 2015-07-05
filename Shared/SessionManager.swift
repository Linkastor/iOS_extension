//
//  SessionManager.swift
//  Linkastor
//
//  Created by Thibaut LE LEVIER on 02/07/2015.
//  Copyright © 2015 Thibaut LE LEVIER. All rights reserved.
//

import UIKit

class SessionManager {
    static let sharedManager = SessionManager()

    private
    let apiKeyStorageKey = "com.linkastor.api_key"
    let userStorageKey = "com.linkastor.user"
    let groupListStorageKey = "com.linkastor.groups"
    let selectedGroupStorageKey = "com.linkastor.selectedgroup"
    let userDefaults = NSUserDefaults(suiteName: "group.com.linkastor.linkastor")

    internal
    var apiKey: String? {
        set {
            if let userDefaults = self.userDefaults {
                userDefaults.setValue(newValue, forKey: apiKeyStorageKey)
                userDefaults.synchronize()
            }
        }
        get {
            if let userDefaults = self.userDefaults {
                return userDefaults.valueForKey(apiKeyStorageKey) as? String
            }
            else {
                return nil
            }
        }
    }

    var user: Dictionary<String, AnyObject>? {
        set {
            if let userDefaults = self.userDefaults {
                userDefaults.setValue(newValue, forKey: userStorageKey)
                userDefaults.synchronize()
            }
        }
        get {
            if let userDefaults = self.userDefaults {
                return userDefaults.valueForKey(userStorageKey) as? Dictionary<String, AnyObject>
            }
            else {
                return nil
            }
        }
    }

    var groups: [Dictionary<String, AnyObject>]? {
        set {
            if let userDefaults = self.userDefaults {
                userDefaults.setValue(newValue, forKey: groupListStorageKey)
                userDefaults.synchronize()
            }
        }
        get {
            if let userDefaults = self.userDefaults {
                return userDefaults.valueForKey(groupListStorageKey) as? [Dictionary<String, AnyObject>]
            }
            else {
                return nil
            }
        }
    }

    var selectedGroup: Dictionary<String, AnyObject>? {
        set {
            if let userDefaults = self.userDefaults {
                userDefaults.setValue(newValue, forKey: selectedGroupStorageKey)
                userDefaults.synchronize()
            }
        }
        get {
            if let userDefaults = self.userDefaults {
                return userDefaults.valueForKey(selectedGroupStorageKey) as? Dictionary<String, AnyObject>
            }
            else {
                return nil
            }
        }
    }

    class func logout() {
        SessionManager.sharedManager.apiKey = nil
        SessionManager.sharedManager.user = nil
        SessionManager.sharedManager.groups = nil
        SessionManager.sharedManager.selectedGroup = nil
    }

}
