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
    static let FirstName = "first_name"
    static let LastName = "last_name"
    static let JobTitle = "job_title"
    static let CompanyName = "company_name"
    static let HoursPerWeek = "hours_per_week"
    static let WagePerHour = "wage_per_hour"
    static let Notes = "notes"
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
        UserSettingsHandler.saveEmployee(employee: employee)
        let notification = NSNotification(name: NotificationKeys.USER_LOGGED_IN, object: self)
        NSNotificationCenter.defaultCenter().postNotification(notification)
    }
    
    class func saveEmployee(employee employee: Employee) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let username = employee.name
        let password = employee.password
        let employer_id = employee.employer_id
        let employee_id = employee.id
        userDefaults.setObject(username, forKey: NSKeys.Username)
        userDefaults.setObject(password, forKey: NSKeys.Password)
        userDefaults.setObject(employer_id, forKey: NSKeys.EmployerId)
        userDefaults.setObject(employee_id, forKey: NSKeys.EmployeeId)
        print(userDefaults.objectForKey(NSKeys.EmployeeId))
        userDefaults.setObject(true, forKey: NSKeys.IsLoggedIn)
        if let employee_first_name = employee.first_name {
            userDefaults.setObject(employee_first_name, forKey: NSKeys.FirstName)
        }
        if let employee_last_name = employee.last_name {
            userDefaults.setObject(employee_last_name, forKey: NSKeys.LastName)
        }
        if let employee_job_title = employee.job_title {
            userDefaults.setObject(employee_job_title, forKey: NSKeys.JobTitle)
        }
        if let employee_company_name = employee.company_name {
            userDefaults.setObject(employee_company_name, forKey: NSKeys.CompanyName)
        }
        if let hours_per_week = employee.hours_per_week {
            userDefaults.setObject(hours_per_week, forKey: NSKeys.HoursPerWeek)
        }
        if let wage_per_hour = employee.wage_per_hour {
            userDefaults.setObject(wage_per_hour, forKey: NSKeys.WagePerHour)
        }
        if let notes = employee.notes {
            userDefaults.setObject(notes, forKey: NSKeys.Notes)
        }
    }
    
    class func saveAddresses(addresses addresses: [String]) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(addresses, forKey: NSKeys.Addresses)
        print(userDefaults.objectForKey(NSKeys.Addresses))
    }
    
    private class func clear() {
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