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

protocol GlobalTimerDelegate {
    func globalTimerSecondsDidChange()
    func userDidLoginOrLogout()
    func userUnableToCheckIn()
}

class GlobalTimer: NSObject {
    
    static let sharedTimer = GlobalTimer()
    
    private var internalTimer: NSTimer?
    private weak var secondsTimer: NSTimer?
    private var addressGetter = GetIPAddress()
    var seconds = -1 {
        didSet {
            secondsHasBeenSet = true
            delegate?.globalTimerSecondsDidChange()
        }
    }
    
    var secondsHasBeenSet = false
    var checkedIn = false
    var delegate: GlobalTimerDelegate?
    
    func startTimer() {
        self.internalTimer?.invalidate()
        self.internalTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(GlobalTimer.addSecond(_:)), userInfo: nil, repeats: false)
    }
    
    func logout() {
        TimesheetService.postTimesheet(checkIn: false, completionHandler: {
            self.checkedIn = false
            self.delegate?.userDidLoginOrLogout()
        })
    }
    
    func login() {
        if !checkedIn {
            TimesheetService.postTimesheet(checkIn: true, completionHandler:  {
                self.checkedIn = true
                self.delegate?.userDidLoginOrLogout()
                self.startTimer()
            })
        }
    }
    
    func checkLogin() {
        if addressGetter.wifiAddressIsInEmployerAddresses() {
            login()
        } else {
            delegate?.userUnableToCheckIn()
            logout()
        }
    }
    
    func addSecond(sender: AnyObject?) {
        if checkedIn {
            seconds += 1
            self.internalTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(GlobalTimer.addSecond(_:)), userInfo: nil, repeats: false)
        }
    }
    
}