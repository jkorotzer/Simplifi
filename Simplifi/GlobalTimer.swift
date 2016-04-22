//
//  GlobalTimer.swift
//  Simplifi
//
//  Created by Jared on 4/11/16.
//  Copyright © 2016 Jared. All rights reserved.
//

import Foundation

extension GetIPAddress {
    func wifiAddressIsInEmployerAddresses() -> Bool {
        let wifiRouterIp = getGatewayIP()
        if let employerAddresses = NSUserDefaults.standardUserDefaults().objectForKey(NSKeys.Addresses) as? NSArray {
            if wifiRouterIp != "nil" {
                let wifiArray = wifiRouterIp.componentsSeparatedByString(".")
                for address in employerAddresses {
                    let addressArray = address.componentsSeparatedByString(".")
                    if addressArray[0] == wifiArray[0] && addressArray[1] == wifiArray[1] && addressArray[3] == wifiArray[3] {
                        return true
                    }
                }
            }
        }
        return false
    }
}

struct NSNotificationCenterKey {
    static let LoginOrLogout = "Login Did Change"
}

class GlobalTimer: NSObject {
    
    class InternalTimer: NSObject {
        
        private var internalTimer: NSTimer?
        private weak var secondsTimer: NSTimer?
        private var timesheetService = TimesheetService()
        private var addressGetter = GetIPAddress()
        var secondsSinceLastLoginCounter = 0
        var checkedIn = false
        
        func startTimer() {
            if !isTimerRunning() {
                internalTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("checkLoginLogout:"), userInfo: nil, repeats: true)
            }
        }
        
        func stopTimer(){
            if isTimerRunning() {
                internalTimer?.invalidate()
            }
        }
        
        func isTimerRunning() -> Bool {
            return internalTimer != nil
        }
        
        func checkLoginLogout(sender: AnyObject?){
            checkLogin()
        }
        
        /*func checkLogout() {
            if !(addressGetter.wifiAddressIsInEmployerAddresses()) {
                logout()
            }
        }*/
        
        func logout() {
            timesheetService.postTimesheet(checkIn: false, completionHandler: {
                self.secondsTimer?.invalidate()
                self.checkedIn = false
                let notification = NSNotification(name: NSNotificationCenterKey.LoginOrLogout, object: nil)
                NSNotificationCenter.defaultCenter().postNotification(notification)
            })
        }
        
        func login() {
            timesheetService.postTimesheet(checkIn: true, completionHandler:  {
                self.checkedIn = true
                self.secondsTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("addSecond:"), userInfo: nil, repeats: true)
            })
            self.stopTimer()
        }
        
        func checkLogin() {
            if addressGetter.wifiAddressIsInEmployerAddresses() {
                login()
            }
        }
        
        func addSecond(sender: AnyObject?) {
            secondsSinceLastLoginCounter++
            let notification = NSNotification(name: NSNotificationCenterKey.LoginOrLogout, object: nil)
            NSNotificationCenter.defaultCenter().postNotification(notification)
        }
        
    }
    
    static var internalTimer = InternalTimer()
    
    static func getSeconds() -> Int {
        return internalTimer.secondsSinceLastLoginCounter
    }
    
    static func isCheckedIn() -> Bool {
        return internalTimer.checkedIn
    }
    
    static func checkout() {
        internalTimer.logout()
    }
}