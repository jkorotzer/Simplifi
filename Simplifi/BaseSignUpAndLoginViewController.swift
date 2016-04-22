//
//  BaseSignUpAndLoginViewController.swift
//  Simplifi
//
//  Created by Jared on 4/13/16.
//  Copyright © 2016 Jared. All rights reserved.
//

import UIKit

class BaseSignUpAndLoginViewController: BaseViewController {

    var loginTimer = NSTimer()
    
    var userSettingsHandler = UserSettingsHandler()
    
    deinit {
        loginTimer.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("checkLogin:"), userInfo: nil, repeats: true)
    }
    
    func checkLogin(sender: AnyObject?) {
        if userSettingsHandler.didSaveAddressesAndDetails() {
            loginTimer.invalidate()
            performSegueWithIdentifier("login", sender: self)
        }
    }
    
}
