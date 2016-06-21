//
//  EmployeeService.swift
//  Temp
//
//  Created by Andrew Moeckel on 3/14/16.
//  Copyright © 2016 payCheck. All rights reserved.
//

import Foundation
import Alamofire

class EmployeeService {
        
    private let url = Settings.viewEmployees
    
    private let loginUrl = Settings.loginEmployee
    
    private let signUpUrl = Settings.signupEmployee
    
    private var addressService = WifiAddressService()
    
    class func requestAllEmployees(completionHandler: ([Employee] -> Void)) {
        
        var employees = [Employee]()
               Alamofire.request(.GET, Settings.viewEmployees)
            .responseJSON {response in
                switch response.result {
                case .Success(let data):
                    
                    let json = JSON(data)
                    for index in 0 ..< json.count {
                        let id = json[index]["id"].int
                        let employer_id = json[index]["employer_id"].int
                        let name = json[index]["name"].string
                        let password = json[index]["password_digest"].string
                        let e:Employee = Employee(employer_id: employer_id!, name: name!, password: password!, id: id!)
                        employees.append(e)
                    }
                completionHandler(employees as [Employee])
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                }
        }

    }
    
    class func requestEmployeeWithId(id: Int, completionHandler: (Employee -> Void), failureCompletionHandler: () -> Void){
        Alamofire.request(.GET, Settings.viewEmployees+"/"+String(id))
        .responseJSON {response in
        switch response.result {
            case .Success(let data):
                let json = JSON(data)
                let employee = Employee(json: json)
//                let employee = Employee(employer_id: json["employer_id"].int!, name: json["name"].string!, password: json["password_digest"].string!, id: json["id"].int!)
                completionHandler(employee as Employee)
//                let first_name = json["first_name"].string ?? ""
//                let last_name = json["last_name"].string ?? ""
//                let job_title = json["job_title"].string ?? ""
//                let company_name = json["company_name"].string ?? ""
//                let hours_per_week = Double(json["hours_per_week"].string!) ?? 0.0
//                let wage_per_hour = Double(json["wage_per_hour"].string!) ?? 0.0
//                let notes = json["notes"].string ?? ""
//                print(notes)
//                employee.first_name = first_name
//                employee.last_name = last_name
//                employee.job_title = job_title
//                employee.company_name = company_name
//                employee.hours_per_week = hours_per_week
//                employee.wage_per_hour = wage_per_hour
//                employee.notes = notes
                UserSettingsHandler.saveEmployee(employee: employee)
        case .Failure(let error):
                failureCompletionHandler()
                print(error)
            }
        }
    }

    class func signUp(e: Employee, employeeCompletionHandler: ((Employee, [String]) -> Void), failureCompletionHandler: () -> Void) {
        Alamofire.request(.POST, Settings.signupEmployee, parameters: ["employee":["employer_id": e.employer_id, "name": e.name, "password": e.password]], encoding: .JSON).validate()
            .responseJSON { response in
                switch response.result {
                case .Success(let data):
                    let json = JSON(data)
                    let id = json["employee"]["id"]
                    if id.error == nil {
                        let employer_id = json["employee"]["employer_id"].int!
                        let name = json["employee"]["name"].string!
                        let password = json["employee"]["password_digest"].string!
                        let e : Employee = Employee(employer_id: employer_id, name: name, password: password, id: json["employee"]["id"].int!)
                        e.id = json["employee"]["id"].int!
                        var addresses = [String]()
                        for index in 0 ..< json["addresses"].count {
                            addresses.append(json["addresses"][index]["address"].string!)
                        }
                        employeeCompletionHandler(e as Employee, addresses as [String])
                    } else {
                        failureCompletionHandler()
                    }
                    break
                case .Failure(let error):
                    print(error)
                    failureCompletionHandler()
                    break
                }
            }
    }
    
    class func updateEmployee(id: Int, e:Employee, completionHandler: (Employee)-> Void, error_handler: ()->Void) {
        let employee_attributes = NSMutableDictionary()
        if let employee_first_name = e.first_name {
            employee_attributes.setObject(employee_first_name, forKey: "first_name")
        }
        if let employee_last_name = e.last_name {
            employee_attributes.setObject(employee_last_name, forKey: "last_name")
        }
        if let employee_job_title = e.job_title {
            employee_attributes.setObject(employee_job_title, forKey: "job_title")
        }
        if let employee_company_name = e.company_name {
            employee_attributes.setObject(employee_company_name, forKey: "company_name")
        }
        if let hours_per_week = e.hours_per_week {
            employee_attributes.setObject(hours_per_week, forKey: "hours_per_week")
        }
        if let wage_per_hour = e.wage_per_hour {
            employee_attributes.setObject(wage_per_hour, forKey: "wage_per_hour")
        }
        if let notes = e.notes {
            employee_attributes.setObject(notes, forKey: "notes")
        }
        Alamofire.request(.PUT, Settings.viewEmployees+"/"+String(id), parameters:["employee":employee_attributes], encoding: .JSON).validate().responseJSON { (response) in
            switch response.result {
            case .Success(let data):
                let json = JSON(data)
                let id = json["id"]
                if id.error == nil {
                    let e = Employee(json: json)
//                    let employer_id = json["employer_id"].int!
//                    let name = json["name"].string!
//                    let password = json["password_digest"].string!
//                    let e : Employee = Employee(employer_id: employer_id, name: name, password: password, id: json["id"].int!)
//                    e.id = json["id"].int!
//                    e.first_name = json["first_name"].string
//                    e.last_name = json["last_name"].string
//                    e.job_title = json["job_title"].string
//                    e.company_name = json["company_name"].string
//                    e.hours_per_week = json["hours_per_week"].double
//                    e.wage_per_hour = json["wage_per_hour"].double
//                    e.notes = json["notes"].string
                    completionHandler(e as Employee)
                } else {
                    error_handler()
                }
                break
            case .Failure(let error):
                print(error)
                error_handler()
                break
            }
        }
    }
    
    class func login(username username: String, password: String, employeeCompletionHandler: ((Employee, [String]) -> Void),wrongLoginHandler: (() -> Void)) {
        Alamofire.request(.POST, Settings.loginEmployee, parameters: ["name": username, "password": password], encoding: .JSON).validate()
            .responseJSON { response in
                switch response.result {
                case .Success(let data):
                    let json = JSON(data)
                    let id = json["employee"]["id"]
                    if id.error == nil {
                        let e = Employee(json: json)
//                        let employer_id = json["employee"]["employer_id"].int!
//                        let name = json["employee"]["name"].string!
//                        let password = json["employee"]["password_digest"].string!
//                        let e : Employee = Employee(employer_id: employer_id, name: name, password: password, id: json["employee"]["id"].int!)
//                        e.id = json["employee"]["id"].int!
//                        e.first_name = json["employee"]["first_name"].string
//                        e.last_name = json["employee"]["last_name"].string
//                        e.job_title = json["employee"]["job_title"].string
//                        e.company_name = json["employee"]["company_name"].string
//                        e.hours_per_week = json["employee"]["hours_per_week"].double
//                        e.wage_per_hour = json["employee"]["wage_per_hour"].double
//                        e.notes = json["employee"]["notes"].string
                        var addresses = [String]()
                        for index in 0 ..< json["addresses"].count {
                            addresses.append(json["addresses"][index]["address"].string!)
                        }
                        employeeCompletionHandler(e as Employee, addresses as [String])
                    } else {
                        wrongLoginHandler()
                    }
                    break
                case .Failure(let error):
                    print(error)
                    wrongLoginHandler()
                    break
                }
            }
    }
        
}


