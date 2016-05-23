//
//  TimesheetService.swift
//  Simplifi
//
//  Created by Jared on 4/12/16.
//  Copyright © 2016 Jared. All rights reserved.
//

import Foundation
import Alamofire

class TimesheetService {
    
    class func postTimesheet(checkIn checkIn: Bool, completionHandler: ()->Void) {
        let currentUrl = Settings.viewEmployees + "/\(NSUserDefaults.standardUserDefaults().objectForKey(NSKeys.EmployeeId) as! Int)/timesheets"
        Alamofire.request(.POST, currentUrl, parameters: ["timesheet":["in": "\(checkIn)"]], encoding: .JSON).validate()
            .responseJSON { response in
                switch response.result {
                case .Success(let data):
                    print(data)
                    completionHandler()
                    break
                case .Failure(let error):
                    print(error)
                    break
                }
        }
    }
    
    class func getTimeForToday(completionHandler: (Int -> Void)) {
        let date = SimplifiUtility.getTodaysDate()
        let currentUrl = Settings.viewEmployees + "/\(NSUserDefaults.standardUserDefaults().objectForKey(NSKeys.EmployeeId) as! Int)/timesheets/time_today"
        Alamofire.request(.POST, currentUrl, parameters: ["time":["year": date.2, "day": date.0, "month": date.1]], encoding: .JSON).validate()
            .responseJSON { response in
                switch response.result {
                case .Success(let data):
                    let seconds = data
                    completionHandler(seconds as! Int)
                    break
                case .Failure(let error):
                    print(error)
                    break
                }
        }
    }
    
    class func getTimesForDays(startDay: Int, numDays: Int, month: Int, year: Int, completionHandler: ([Int] -> Void), errorHandler: () -> Void) {
        let url = Settings.viewEmployees + "/\(NSUserDefaults.standardUserDefaults().objectForKey(NSKeys.EmployeeId) as! Int)/timesheets/time"
        Alamofire.request(.POST, url, parameters: ["time":["year": year, "month": month, "start_day": startDay, "num_days": numDays]], encoding: .JSON).validate().responseJSON { (response) in
            switch response.result {
            case .Success(let data):
                let times = data as! [Int]
                completionHandler(times as [Int])
                break
            case .Failure(let error):
                print(error)
                errorHandler()
                break
            }
        }
    }
    
}