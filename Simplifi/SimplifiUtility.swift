//
//  SimplifiUtility.swift
//  Simplifi
//
//  Created by Jared on 5/19/16.
//  Copyright © 2016 Jared. All rights reserved.
//

import Foundation

class SimplifiUtility {
    
    class func getTodaysDate() -> (Int, Int, Int) {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: date)
        let year =  components.year
        let month = components.month
        let day = components.day
        return (day, month, year)
    }
    
}