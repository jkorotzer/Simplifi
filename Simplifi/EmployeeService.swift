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
                        let e:Employee = Employee(employer_id: employer_id!, name: name!, password: password!)
                        e.id = id!
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
                if(json.isEmpty){
                    print("json is empty")
                }
                else {
                    let employee = Employee(employer_id: json["employer_id"].int!, name: json["name"].string!, password: json["password_digest"].string!)
                    employee.id = json["id"].int!
                    completionHandler(employee as Employee)
                }
            case .Failure(let error):
                failureCompletionHandler()
                print(error)
            }
        }
    }

    class func signUp(e: Employee, employeeCompletionHandler: ((Employee, [String]) -> Void), failureCompletionHandler: () -> Void) {
        print(e)
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
                        let e : Employee = Employee(employer_id: employer_id, name: name, password: password)
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
    
    class func updateEmployee(id: Int, e:Employee) {
        Alamofire.request(.PUT, Settings.viewEmployees+"/"+String(id), parameters:["employee":["employer_id":e.employer_id, "name": e.name, "password":e.password]], encoding: .JSON)
    }
    
    class func login(username username: String, password: String, employeeCompletionHandler: ((Employee, [String]) -> Void),wrongLoginHandler: (() -> Void)) {
        Alamofire.request(.POST, Settings.loginEmployee, parameters: ["name": username, "password": password], encoding: .JSON).validate()
            .responseJSON { response in
                switch response.result {
                case .Success(let data):
                    let json = JSON(data)
                    let id = json["employee"]["id"]
                    if id.error == nil {
                        let employer_id = json["employee"]["employer_id"].int!
                        let name = json["employee"]["name"].string!
                        let password = json["employee"]["password_digest"].string!
                        let e : Employee = Employee(employer_id: employer_id, name: name, password: password)
                        e.id = json["employee"]["id"].int!
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


