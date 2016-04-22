//
//  EmployerIdViewController.swift
//  Simplifi
//
//  Created by Jared on 4/3/16.
//  Copyright © 2016 Jared. All rights reserved.
//

import UIKit

class EmployerIdViewController: BaseSignUpAndLoginViewController {
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    var username : String!
    
    var password : String!
    
    private var employeeService = EmployeeService()
    
    private var userSettings = UserSettingsHandler()
    

    @IBOutlet weak var employerIdTextField: HoshiTextField! {
        didSet {
            setupHoshiTextField(employerIdTextField, placeholder: "Please enter your Employer's ID")
            employerIdTextField.keyboardType = .NumberPad
        }
    }
    
    @IBOutlet weak var submitButton: UIButton! {
        didSet {
            setupSimplifiButton(submitButton)
        }
    }
    
    @IBAction func submit(sender: UIButton) {
        if let string = employerIdTextField.text {
            if let num = Int(string) {
                let employee = Employee(employer_id: num, name: username, password: password)
                employeeService.signUp(employee, employeeCompletionHandler: {[unowned self]
                    employee in
                        self.displayActivityIndicator("Signing up", true)
                        self.userSettings.signUpAndLogin(employee: employee)
                    },
                    addressCompletionHandler: {[unowned self]
                    addresses in
                        self.displayActivityIndicator("Getting wifi addresses...", true)
                        self.userSettings.saveAddresses(addresses: addresses)
                    },
                    failureCompletionHandler: {[unowned self]
                        in
                        let alertController = UIAlertController(title: "Unable to sign up", message: "Please try again.", preferredStyle: .Alert)
                        alertController.addAction(UIAlertAction(title: "Try again", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alertController, animated: true, completion: nil)
                })
            }
        }
        
    }
}
