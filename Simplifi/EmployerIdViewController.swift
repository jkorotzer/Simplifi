//
//  EmployerIdViewController.swift
//  Simplifi
//
//  Created by Jared on 4/3/16.
//  Copyright © 2016 Jared. All rights reserved.
//

import UIKit

class EmployerIdViewController: BaseViewController {
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    var username : String!
    
    var password : String!
    
    private var employeeService = EmployeeService()

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
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func submit(sender: UIButton) {
        if let string = employerIdTextField.text {
            if let num = Int(string) {
                self.displayActivityIndicator("Signing up", true)
                let employee = Employee(employer_id: num, name: username, password: password)
                EmployeeService.signUp(employee, employeeCompletionHandler: {[unowned self]
                    (employee, addresses) in
                        UserSettingsHandler.signUpAndLogin(employee: employee)
                        UserSettingsHandler.saveAddresses(addresses: addresses)
                        self.removeActivityIndicator()
                        self.performSegueWithIdentifier("login", sender: self)
                    },
                    failureCompletionHandler: {[unowned self]
                        in
                        self.removeActivityIndicator()
                        let alertController = UIAlertController(title: "Unable to sign up", message: "Please try again.", preferredStyle: .Alert)
                        alertController.addAction(UIAlertAction(title: "Try again", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alertController, animated: true, completion: nil)
                })
            }
        }
        
    }
}
