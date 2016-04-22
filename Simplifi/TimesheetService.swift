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
    
    private var url = Settings().viewEmployees
    
    func postTimesheet(checkIn checkIn: Bool, completionHandler: ()->Void) {
        let currentUrl = url + "/\(NSUserDefaults.standardUserDefaults().objectForKey(NSKeys.EmployeeId) as! Int)/timesheets"
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
    
    func getTimeForDay(year year: Int, month: Int, day: Int, completionHandler: (Int -> Void)) {
        let currentUrl = url + "/\(NSUserDefaults.standardUserDefaults().objectForKey(NSKeys.EmployeeId) as! Int)/timesheets/time"
        Alamofire.request(.POST, currentUrl, parameters: ["time":["year": year, "day": day, "month": month]], encoding: .JSON).validate()
            .responseJSON { response in
                switch response.result {
                case .Success(let data):
                    let seconds = data
                    print(data)
                    completionHandler(seconds as! Int)
                    break
                case .Failure(let error):
                    print(error)
                    break
                }
        }
    }
    
}