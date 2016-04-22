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

class UserSettingsHandler {
    
    private let userDefaults = NSUserDefaults.standardUserDefaults()
    
    func isLoggedIn() -> Bool {
        if let _ = userDefaults.stringForKey(NSKeys.IsLoggedIn) {
            let result = userDefaults.objectForKey(NSKeys.IsLoggedIn)
            return result as! Bool
        }
        return false
    }
    
    func signUpAndLogin(employee employee: Employee) {
        let username = employee.name 
        let password = employee.password
        let employer_id = employee.employer_id
        let employee_id = employee.id
        userDefaults.setObject(username, forKey: NSKeys.Username)
        userDefaults.setObject(password, forKey: NSKeys.Password)
        userDefaults.setObject(employer_id, forKey: NSKeys.EmployerId)
        userDefaults.setObject(employee_id, forKey: NSKeys.EmployeeId)
        userDefaults.setObject(true, forKey: NSKeys.IsLoggedIn)
        print(userDefaults.objectForKey(NSKeys.Username))
        print(userDefaults.objectForKey(NSKeys.Password))
        print(userDefaults.objectForKey(NSKeys.EmployerId))
        print(userDefaults.objectForKey(NSKeys.EmployeeId))
        print(userDefaults.objectForKey(NSKeys.IsLoggedIn))
    }
    
    func saveAddresses(addresses addresses: [String]) {
        userDefaults.setObject(addresses, forKey: NSKeys.Addresses)
        print(userDefaults.objectForKey(NSKeys.Addresses))
    }
    
    func didSaveAddressesAndDetails() -> Bool {
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
    
    func clear() {
        for key in Array(NSUserDefaults.standardUserDefaults().dictionaryRepresentation().keys) {
            NSUserDefaults.standardUserDefaults().removeObjectForKey(key)
        }
    }
    
    func appHasAlreadyLaunchedBefore() -> Bool {
        if let _ = userDefaults.stringForKey(NSKeys.HasAlreadyLaunched) {
            return true
        } else {
            userDefaults.setBool(true, forKey: NSKeys.HasAlreadyLaunched)
            return false
        }
    }
    
}