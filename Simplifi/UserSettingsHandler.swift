//
//  UserSettingsHandler.swift
//  Simplifi
//
//  Created by Jared on 4/7/16.
//  Copyright © 2016 Jared. All rights reserved.
//

import Foundation

struct NSKeys {
    static let IsLoggedIn = "isLoggedIn"
    static let HasAlreadyLaunched = "hasLaunched"
    static let Username = "username"
    static let Password = "password"
    static let EmployerId = "employer_id"
    static let EmployeeId = "employee_id"
    static let Addresses = "addresses"
}

struct NotificationKeys {
    static let USER_LOGGED_IN = "userLoggedIn"
}

class UserSettingsHandler {
    
    class func isLoggedIn() -> Bool {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let _ = userDefaults.stringForKey(NSKeys.IsLoggedIn) {
            let result = userDefaults.objectForKey(NSKeys.IsLoggedIn)
            return result as! Bool
        }
        return false
    }
    
    class func signUpAndLogin(employee employee: Employee) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let username = employee.name
        let password = employee.password
        let employer_id = employee.employer_id
        let employee_id = employee.id
        userDefaults.setObject(username, forKey: NSKeys.Username)
        userDefaults.setObject(password, forKey: NSKeys.Password)
        userDefaults.setObject(employer_id, forKey: NSKeys.EmployerId)
        userDefaults.setObject(employee_id, forKey: NSKeys.EmployeeId)
        userDefaults.setObject(true, forKey: NSKeys.IsLoggedIn)
        let notification = NSNotification(name: NotificationKeys.USER_LOGGED_IN, object: self)
        NSNotificationCenter.defaultCenter().postNotification(notification)
        print(userDefaults.objectForKey(NSKeys.Username))
        print(userDefaults.objectForKey(NSKeys.Password))
        print(userDefaults.objectForKey(NSKeys.EmployerId))
        print(userDefaults.objectForKey(NSKeys.EmployeeId))
        print(userDefaults.objectForKey(NSKeys.IsLoggedIn))
    }
    
    class func saveAddresses(addresses addresses: [String]) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(addresses, forKey: NSKeys.Addresses)
        print(userDefaults.objectForKey(NSKeys.Addresses))
    }
    
    class func didSaveAddressesAndDetails() -> Bool {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if userDefaults.objectForKey(NSKeys.Username) != nil {
            if userDefaults.objectForKey(NSKeys.Password) != nil {
                if userDefaults.objectForKey(NSKeys.EmployerId) != nil {
                    if userDefaults.objectForKey(NSKeys.EmployeeId) != nil {
                        if userDefaults.objectForKey(NSKeys.IsLoggedIn) != nil {
                            if userDefaults.objectForKey(NSKeys.Addresses) != nil {
                                return true
                            }
                        }
                    }
                }
            }
        }
        return false
    }
    
    class func clear() {
        for key in Array(NSUserDefaults.standardUserDefaults().dictionaryRepresentation().keys) {
            NSUserDefaults.standardUserDefaults().removeObjectForKey(key)
        }
    }
    
    class func appHasAlreadyLaunchedBefore() -> Bool {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let _ = userDefaults.stringForKey(NSKeys.HasAlreadyLaunched) {
            return true
        } else {
            userDefaults.setBool(true, forKey: NSKeys.HasAlreadyLaunched)
            return false
        }
    }
    
    class func logout() {
        UserSettingsHandler.clear()
    }
    
}