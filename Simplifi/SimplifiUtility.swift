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
        var day = components.day
        //database is UTC time so convert and check if we need tomorrow's time
        let UTCcalendar = NSCalendar.currentCalendar()
        UTCcalendar.timeZone = NSTimeZone(name: "UTC")!
        let UTCcomponents = calendar.components([.Day , .Month , .Year], fromDate: date)
        let UTCday = UTCcomponents.day
        if UTCday > day {
            day = UTCday
        }
        return (day, month, year)
    }
    
    class func tupleFromDate(date: NSDate) -> (Int, Int, Int) {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: date)
        let year =  components.year
        let month = components.month
        let day = components.day
        return (day, month, year)
    }
    
    class func getWeekDaysInEnglish() -> [String] {
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        calendar.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        return calendar.weekdaySymbols
    }
    
    enum SearchDirection {
        case Next
        case Previous
        
        var calendarOptions: NSCalendarOptions {
            switch self {
            case .Next:
                return .MatchNextTime
            case .Previous:
                return [.SearchBackwards, .MatchNextTime]
            }
        }
    }
    
    class func getDay(direction: SearchDirection, _ dayName: String, considerToday consider: Bool = false) -> NSDate {
        let weekdaysName = getWeekDaysInEnglish()
        
        assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")
        
        let nextWeekDayIndex = weekdaysName.indexOf(dayName)! + 1 // weekday is in form 1 ... 7 where as index is 0 ... 6
        
        let today = NSDate()
        
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        
        if consider && calendar.component(.Weekday, fromDate: today) == nextWeekDayIndex {
            return today
        }
        
        let nextDateComponent = NSDateComponents()
        nextDateComponent.weekday = nextWeekDayIndex
        
        let date = calendar.nextDateAfterDate(today, matchingComponents: nextDateComponent, options: direction.calendarOptions)
        return date!
    }
    
    class func timeStringForSeconds(seconds: Int) -> String {
        let hours = seconds / 3600
        let hoursString = NSString(format: "%02d", hours)
        let currentMinutes = (seconds % 3600) / 60
        let minutesString = NSString(format: "%02d", currentMinutes)
        let secondsString = NSString(format: "%02d", (seconds % 3600) % 60)
        return "\(hoursString):\(minutesString):\(secondsString)"
    }
    
}