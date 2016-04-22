//
//  ClockViewController.swift
//  Simplifi
//
//  Created by Jared on 4/4/16.
//  Copyright © 2016 Jared. All rights reserved.
//

import UIKit

class ClockViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateUI:", name: NSNotificationCenterKey.LoginOrLogout, object: nil)
        setSecondsAndStartTimer()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    private var secondsToday = 0 {
        didSet {
            updateUI()
        }
    }
    
    private var timesheetService = TimesheetService()
    
    @IBOutlet weak var clockButton: UIButton! {
        didSet {
            setupSimplifiButton(clockButton)
            clockButton.layer.cornerRadius = 0.5 * clockButton.bounds.size.width
        }
    }
    
    @IBOutlet weak var instructionLabel: UILabel! {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var clockLabel: UILabel! {
        didSet {
            clockLabel.text = "00:00"
        }
    }
    
    @IBAction func clockButtonPressed(sender: UIButton) {
        if GlobalTimer.isCheckedIn() {
            GlobalTimer.internalTimer.logout()
            GlobalTimer.internalTimer.stopTimer()
        } else {
            GlobalTimer.internalTimer.checkLogin()
        }
    }
    
    func updateUI(notification: NSNotification) {
        updateUI()
    }
    
    private func updateUI() {
        if GlobalTimer.isCheckedIn() {
            let seconds = GlobalTimer.getSeconds() + secondsToday
            let hours = seconds / 3600
            let hoursString = NSString(format: "%02d", hours)
            let currentMinutes = (seconds % 3600) / 60
            let minutesString = NSString(format: "%02d", currentMinutes)
            let secondsString = NSString(format: "%02d", GlobalTimer.getSeconds())
            clockLabel.text = "\(hoursString):\(minutesString):\(secondsString)"
            instructionLabel.text = "Take a break or check out:"
            clockButton.setTitle("Break", forState: .Normal)
        } else {
            instructionLabel.text = "Check in for work:"
            clockButton.setTitle("Start", forState: .Normal)
        }
    }
    
    private func setSecondsAndStartTimer() {
        
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: date)
        let year =  components.year
        let month = components.month
        let day = components.day
        displayActivityIndicator("Getting time...", true)
        timesheetService.getTimeForDay(year: year, month: month, day: day) { [unowned self]
            seconds in
            self.secondsToday = seconds
            GlobalTimer.internalTimer.startTimer()
            dispatch_async(dispatch_get_main_queue()){
                if let activityView = self.view.viewWithTag(100) {
                    activityView.removeFromSuperview()
                }
            }
        }
    }
}
