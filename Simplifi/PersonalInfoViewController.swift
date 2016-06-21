//
//  PersonalInfoViewController.swift
//  Simplifi
//
//  Created by Jared on 5/27/16.
//  Copyright © 2016 Jared. All rights reserved.
//

import UIKit

class PersonalInfoViewController: BaseTableViewController, InformationTableViewCellTableView, TextViewBaseCellTableView {
    
    private let infoIndentifier = "info"
    private let textViewIdentifier = "text"
    private let buttonIdentifier = "button"
    private var employee =  Employee(employer_id: 0, name: "", password: "", id: NSUserDefaults.standardUserDefaults().integerForKey(NSKeys.EmployeeId))
    private var finishedLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.displayActivityIndicator("Fetching info...", true)
        EmployeeService.requestEmployeeWithId(NSUserDefaults.standardUserDefaults().integerForKey(NSKeys.EmployeeId), completionHandler: { (employee) in
                self.employee = employee
                self.removeActivityIndicator()
                self.finishedLoading = true
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
            }) { 
                self.removeActivityIndicator()
                let action = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
                let alertController = UIAlertController(title: "Oops!", message: "We were unable to fetch your information.", preferredStyle: .Alert)
                alertController.addAction(action)
                self.presentViewController(alertController, animated: true, completion: nil)
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "save", style: .Plain, target: self, action: #selector(PersonalInfoViewController.save))
        //self.tableView.scrollEnabled = false
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return finishedLoading ? 3 : 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !finishedLoading {
            return 0
        }
        switch section {
        case 0:
            return 3
        case 1:
            return 3
        case 2:
            return 2
        default: assert(false, "Too many sections?")
        }
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "About you"
        case 1:
            return "About your work"
        case 2:
            return "Goals/Notes"
        default: assert(false, "Too many sections?")
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        switch (indexPath.section, indexPath.row) {
        case (0,0):
            cell = tableView.dequeueReusableCellWithIdentifier(self.infoIndentifier) as! InformationEnterBaseCell
            self.informationCell(cell as! InformationEnterBaseCell, withInstructions: "First name", andAnswer: employee.first_name!)
        case (0,1):
            cell = tableView.dequeueReusableCellWithIdentifier(self.infoIndentifier) as! InformationEnterBaseCell
            self.informationCell(cell as! InformationEnterBaseCell, withInstructions: "Last name", andAnswer: employee.last_name!)
        case (0,2):
            cell = tableView.dequeueReusableCellWithIdentifier(self.infoIndentifier) as! InformationEnterBaseCell
            self.informationCell(cell as! InformationEnterBaseCell, withInstructions: "Job title", andAnswer: employee.job_title!)
        case (1,0):
            cell = tableView.dequeueReusableCellWithIdentifier(self.infoIndentifier) as! InformationEnterBaseCell
            self.informationCell(cell as! InformationEnterBaseCell, withInstructions: "Company name", andAnswer: employee.company_name!)
        case (1,1):
            cell = tableView.dequeueReusableCellWithIdentifier(self.infoIndentifier) as! InformationEnterBaseCell
            self.informationCell(cell as! InformationEnterBaseCell, withInstructions: "Target hours per week", andAnswer: employee.hours_per_week == 0 ? "" : "\(employee.hours_per_week!)")
        case (1,2):
            cell = tableView.dequeueReusableCellWithIdentifier(self.infoIndentifier) as! InformationEnterBaseCell
            self.informationCell(cell as! InformationEnterBaseCell, withInstructions: "Wage per hour", andAnswer: employee.wage_per_hour! == 0 ? "" : "\(employee.wage_per_hour!)")
        case (2,0):
            cell = tableView.dequeueReusableCellWithIdentifier(self.textViewIdentifier) as! TextViewBaseCell
            self.textViewCell(cell as! TextViewBaseCell, withInstructions: "Enter any goals/notes you wish!", andAnswer: employee.notes!)
        case (2,1):
            cell = tableView.dequeueReusableCellWithIdentifier(self.buttonIdentifier)
            self.buttonCell(cell as! ButtonCell, withTitle: "Logout", andAction: #selector(PersonalInfoViewController.logoutPressed))
        default: assert(false, "Too many rows?")
        }
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
        case (2,0):
            return 150
        default: return UITableViewAutomaticDimension
        }
    }
    
    func informationTextFieldReturn() {
        self.view.endEditing(true)
    }
    
    func informationTextDidChange(sender: InformationEnterBaseCell) {
        let indexPath = self.tableView.indexPathForCell(sender)
        switch (indexPath!.section, indexPath!.row) {
        case (0,0):
            self.employee.first_name = sender.textfield.text
        case (0,1):
            self.employee.last_name = sender.textfield.text
        case (0,2):
            self.employee.job_title = sender.textfield.text
        case (1,0):
            self.employee.company_name = sender.textfield.text
        case (1,1):
            if let hours = Double(sender.textfield.text!) {
                self.employee.hours_per_week = hours
            }
        case (1,2):
            if let wage = Double(sender.textfield.text!) {
                self.employee.wage_per_hour = wage
            }
        default: assert(false, "Too many rows?")
        }
    }
    
    func textViewTextDidChange(sender: TextViewBaseCell) {
        self.employee.notes = sender.informationEnterTextView.text
    }
    
    func logoutPressed() {
        UserSettingsHandler.logout()
        self.performSegueWithIdentifier("logout", sender: self)
    }
    
    func save() {
        self.displayActivityIndicator("Saving...", true)
        print(employee)
        EmployeeService.updateEmployee(employee.id, e: employee, completionHandler: {
            employee in
            UserSettingsHandler.saveEmployee(employee: employee)
            self.removeActivityIndicator()
            }, error_handler: {
                let controller = UIAlertController(title: "We are having trouble saving your attributes. Please try again.", message: nil, preferredStyle: .Alert)
                self.presentViewController(controller, animated: true, completion: nil)
        })
    }
    
    private func buttonCell(cell: ButtonCell, withTitle title: String, andAction action: Selector) {
        cell.configureButton(withTarget: self, andAction: action, andTitle: title)
    }
    
    private func informationCell(cell: InformationEnterBaseCell, withInstructions instructions: String, andAnswer answer: String) {
        cell.configureWithInstructions(instructions, andAnswer: answer)
        cell.delegate = self
    }
    
    private func textViewCell(cell: TextViewBaseCell, withInstructions instructions: String, andAnswer answer: String) {
        cell.configureWithInstructions(instructions, andAnswer: answer)
        cell.delegate = self
    }
    
    override func registerCells() {
        self.tableView.registerClass(InformationEnterBaseCell.self, forCellReuseIdentifier: infoIndentifier)
        self.tableView.registerClass(TextViewBaseCell.self, forCellReuseIdentifier: textViewIdentifier)
        self.tableView.registerClass(ButtonCell.self, forCellReuseIdentifier: buttonIdentifier)
    }

}
