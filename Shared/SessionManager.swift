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
    let groupListStorageKey = "com.linkastor.groups"
    let selectedGroupStorageKey = "com.linkastor.selectedgroup"

    internal
    var apiKey: String? {
        set {
            NSUserDefaults.standardUserDefaults().setValue(newValue, forKey: apiKeyStorageKey)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        get {
            return NSUserDefaults.standardUserDefaults().valueForKey(apiKeyStorageKey) as? String
        }
    }

    var groups: [Dictionary<String, AnyObject>]? {
        set {
            NSUserDefaults.standardUserDefaults().setValue(newValue, forKey: groupListStorageKey)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        get {
            return NSUserDefaults.standardUserDefaults().valueForKey(groupListStorageKey) as? [Dictionary<String, AnyObject>]
        }
    }

    var selectedGroup: Dictionary<String, AnyObject>? {
        set {
            NSUserDefaults.standardUserDefaults().setValue(newValue, forKey: selectedGroupStorageKey)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        get {
            return NSUserDefaults.standardUserDefaults().valueForKey(selectedGroupStorageKey) as? Dictionary<String, AnyObject>
        }
    }

    class func logout() {
        SessionManager.sharedManager.apiKey = nil
        SessionManager.sharedManager.groups = nil
        SessionManager.sharedManager.selectedGroup = nil
    }

}
