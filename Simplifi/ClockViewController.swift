//
//  ClockViewController.swift
//  Simplifi
//
//  Created by Jared on 4/4/16.
//  Copyright © 2016 Jared. All rights reserved.
//

import UIKit

class ClockViewController: BaseViewController, GlobalTimerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        GlobalTimer.sharedTimer.delegate = self
        if GlobalTimer.sharedTimer.secondsHasBeenSet {
            GlobalTimer.sharedTimer.checkLogin()
        }
        updateUI()
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
        if GlobalTimer.sharedTimer.secondsHasBeenSet {
            if GlobalTimer.sharedTimer.checkedIn {
                GlobalTimer.sharedTimer.logout()
            } else {
                GlobalTimer.sharedTimer.checkLogin()
            }
        }
    }
    
    func globalTimerSecondsDidChange() {
        updateUI()
    }
    
    func userDidLoginOrLogout() {
        updateUI()
    }
    
    func userUnableToCheckIn() {
        let alertController = UIAlertController(title: "Oops!", message: "You do not appear to be on your employer's wifi! Please connect and try again.", preferredStyle: .Alert)
        let alertAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(alertAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    private func updateUI() {
        if GlobalTimer.sharedTimer.secondsHasBeenSet {
            let seconds = GlobalTimer.sharedTimer.seconds
            clockLabel.text = SimplifiUtility.timeStringForSeconds(seconds)
            if GlobalTimer.sharedTimer.checkedIn {
                instructionLabel.text = "Take a break or check out:"
                clockButton.setTitle("Break", forState: .Normal)
            } else {
                instructionLabel.text = "Check in for work:"
                clockButton.setTitle("Start", forState: .Normal)
            }
        } else {
            instructionLabel.text = "Please wait..."
        }
    }
}
