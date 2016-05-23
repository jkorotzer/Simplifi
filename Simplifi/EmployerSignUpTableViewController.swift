//
//  EmployerSignUpTableViewController.swift
//  Simplifi
//
//  Created by Jared on 5/20/16.
//  Copyright © 2016 Jared. All rights reserved.
//

import UIKit

class EmployerSignUpTableViewController: BaseTableViewController, InformationTableViewCellTableView, TextViewBaseCellTableView {
    
    private let informationIdentifier = "information"
    
    private var email = ""
    
    private var password = ""
    
    private var company_name = ""
    
    private var addresses = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "save", style: .Plain, target: self, action: #selector(EmployerSignUpTableViewController.save))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "cancel", style: .Plain, target: self, action: #selector(EmployerSignUpTableViewController.cancel))
        self.title = "Welcome"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        switch indexPath.row {
        case 0:
            cell = self.informationCell(withInstructions: "Please enter your email.", andAnswer: self.email)
            break
        case 1:
            cell = self.informationCell(withInstructions: "Please enter your password.", andAnswer: self.password)
            if let passwordCell = cell as? InformationEnterBaseCell {
                passwordCell.textfield.secureTextEntry = true
            }
            break
        case 2:
            cell = self.informationCell(withInstructions: "Please enter your company's name", andAnswer: self.company_name)
            break
        case 3:
            cell = self.textViewCell(withInstructions: "Please enter all wifi routing numbers your employees may connect to seperated by a semicolon. Ex: 123.45.67.8; 123.45.67.8", andAnswer: addresses)
            break
        default:
            assert(false, "Were rows added?")
        }
        return cell!
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 3 {
            return 150
        }
        return 60
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Welcome to Simplifi!"
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }

    
    func save(sender: AnyObject) {
        self.view.endEditing(true)
        if self.email == "" || self.password == "" || self.company_name == "" || self.addresses == "" {
            let controller = UIAlertController(title: "Oops!", message: "You did not fill out all the necessary information. Please fill out all the fields and try again.", preferredStyle: .Alert)
            controller.addAction(UIAlertAction(title: "Ok!", style: .Cancel, handler: nil))
            self.presentViewController(controller, animated: true, completion: nil)
        } else {
            self.displayActivityIndicator("Signing up...", true)
            let e = Employer(id: 0, name: self.email, password: self.password, company_name: self.company_name)
            EmployerService.signUpEmployer(e, completionHandler: { (employer) in
                let id = employer.id
                var addresses = self.addresses.componentsSeparatedByString(";")
                addresses = addresses.map({ $0.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) })
                WifiAddressService.postAddresses(addresses, employer_id: id, completionHandler: { 
                    self.removeActivityIndicator()
                    let controller = UIAlertController(title: "Done!", message: "You have been successfully signed up. Your employer id is \(id).", preferredStyle: .Alert)
                    controller.addAction(UIAlertAction(title: "Ok!", style: .Cancel, handler: { (action) in
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }))
                    self.presentViewController(controller, animated: true, completion: nil)
                    }, errorHandler: {
                        self.removeActivityIndicator()
                        let controller = UIAlertController(title: "Oops!", message: "There was an error in adding your addresses. Please make sure they are seperated by a semicolon and try again.", preferredStyle: .Alert)
                        controller.addAction(UIAlertAction(title: "Ok!", style: .Cancel, handler: nil))
                        self.presentViewController(controller, animated: true, completion: nil)
                })
            })
        }
    }
    
    func cancel(sender: AnyObject) {
        self.view.endEditing(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func informationTextDidChange(sender: InformationEnterBaseCell) {
        let indexPath = self.tableView.indexPathForCell(sender)
        switch indexPath!.row {
        case 0:
            self.email = sender.textfield.text!
            print(self.email)
            break
        case 1:
            self.password = sender.textfield.text!
            print(self.password)
            break
        case 2:
            self.company_name = sender.textfield.text!
            print(self.company_name)
            break
        default:
            assert(false, "There should only be three information enter cells")
        }
    }
    
    func informationTextFieldReturn() {
        self.view.endEditing(true)
    }
    
    func textViewTextDidChange(sender: TextViewBaseCell) {
        self.addresses = sender.informationEnterTextView.text
        print(addresses)
    }
    
    override func registerCells() {
        tableView.registerClass(InformationEnterBaseCell.self, forCellReuseIdentifier: informationIdentifier)
    }
    
    private func informationCell(withInstructions instructions: String, andAnswer answer: String) -> InformationEnterBaseCell {
        let cell = InformationEnterBaseCell()
        cell.configureWithInstructions(instructions, andAnswer: answer)
        cell.delegate = self
        return cell
    }
    
    private func textViewCell(withInstructions instructions: String, andAnswer answer: String) -> TextViewBaseCell {
        let cell = TextViewBaseCell()
        cell.configureWithInstructions(instructions, andAnswer: answer)
        cell.delegate = self
        return cell
    }
}
