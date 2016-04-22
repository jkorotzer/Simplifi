//
//  FrontPageViewController.swift
//  payCheck
//
//  Created by Jared on 2/27/16.
//  Copyright © 2016 Jared. All rights reserved.
//

import UIKit
import Alamofire

class FrontPageViewController: BaseSignUpAndLoginViewController {
    
    private var employeeService = EmployeeService()
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        padding = 10
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        lowestItemHeight = self.view.frame.size.height - (loginButton.superview!.frame.origin.y + loginButton.frame.origin.y + loginButton.frame.size.height)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBOutlet weak var signUpButton: UIButton! {
        didSet {
            setupSimplifiButton(signUpButton)
        }
    }
    
    @IBOutlet weak var loginButton: UIButton! {
        didSet {
            setupSimplifiButton(loginButton)
        }
    }
    
    @IBOutlet weak var registerCompanyButton: UIButton! {
        didSet {
            registerCompanyButton.setTitleColor(SimplifiColor(), forState: .Normal)
        }
    }
    
    @IBOutlet weak var usernameLabel: HoshiTextField! {
        didSet {
            setupHoshiTextField(usernameLabel, placeholder: "Enter your username")
        }
    }
    
    @IBOutlet weak var passwordLabel: HoshiTextField! {
        didSet {
            setupHoshiTextField(passwordLabel, placeholder: "Enter your password")
            passwordLabel.secureTextEntry = true
        }
    }
    
    
    
    @IBAction func signUp(sender: UIButton) {
        if usernameLabel.text != "" && passwordLabel.text != "" {
            performSegueWithIdentifier("signUp", sender: self)
        }
    }
    
    @IBAction func login(sender: UIButton) {
        if usernameLabel.text != "" && passwordLabel.text != "" {
            employeeService.login(username: usernameLabel.text!, password: passwordLabel.text!, employeeCompletionHandler:  {[unowned self]
                employee in
                self.userSettingsHandler.signUpAndLogin(employee: employee)
                dispatch_async(dispatch_get_main_queue()){
                    self.displayActivityIndicator("Logging in...", true)
                }
                }, addressCompletionHandler: {[unowned self]
                    addresses in
                    self.userSettingsHandler.saveAddresses(addresses: addresses)
                }, wrongLoginHandler: {
                    [unowned self] in
                    self.passwordLabel.text = "";
                    self.userSettingsHandler.clear()
                    let alert = UIAlertController(title: "Login Failed", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Try again", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                })
            }
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "signUp":
                let navCon = segue.destinationViewController as! UINavigationController
                let destination = navCon.topViewController as! EmployerIdViewController
                destination.username = usernameLabel.text
                destination.password = passwordLabel.text
                break
            default: break
            }
        }
    }
    

}
