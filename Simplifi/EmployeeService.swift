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
    
    private var userSettingsHandler = UserSettingsHandler()
    
    private let url = Settings().viewEmployees
    
    private let loginUrl = Settings().loginEmployee
    
    private var addressService = WifiAddressService()
    
    func requestAllEmployees(completionHandler: ([Employee] -> Void)) {
        
        var employees = [Employee]()
               Alamofire.request(.GET, url)
            .responseJSON {response in
                switch response.result {
                case .Success(let data):
                    
                    let json = JSON(data)
                    //print(json)
                    for var index = 0; index<json.count; ++index {
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
    
    func requestEmployeeWithId(id: Int,completionHandler: (Employee -> Void)){
        Alamofire.request(.GET, url+"/"+String(id))
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
                print(error)
                print("json is empty")
            }
        }
    }

    func signUp(e: Employee, employeeCompletionHandler: (Employee -> Void), addressCompletionHandler: ([String] -> Void), failureCompletionHandler: () -> Void) {
        
        Alamofire.request(.POST, url, parameters: ["employee":["employer_id": e.employer_id, "name": e.name, "password": e.password]], encoding: .JSON).validate()
            .responseJSON { response in
                switch response.result {
                case .Success(let data):
                    let json = JSON(data)
                    let id = json["id"]
                    if id.error == nil {
                        let employer_id = json["employer_id"].int!
                        let name = json["name"].string!
                        let password = json["password_digest"].string!
                        let e : Employee = Employee(employer_id: employer_id, name: name, password: password)
                        e.id = json["id"].int!
                        self.addressService.getAddressesByEmployerId(employer_id: employer_id, completionHandler: addressCompletionHandler, failureCompletionHandler: failureCompletionHandler)
                        employeeCompletionHandler(e as Employee)
                    } else {
                        failureCompletionHandler()
                    }
                    break
                case .Failure(let error):
                    failureCompletionHandler()
                    break
                }
            }
    }
    
    func updateEmployee(id: Int, e:Employee) {
        Alamofire.request(.PUT, url+"/"+String(id), parameters:["employee":["employer_id":e.employer_id, "name": e.name, "password":e.password]], encoding: .JSON)
    }
    
    func login(username username: String, password: String, employeeCompletionHandler: (Employee -> Void), addressCompletionHandler: ([String] -> Void), wrongLoginHandler: (() -> Void)) {
        Alamofire.request(.POST, loginUrl, parameters: ["name": username, "password": password], encoding: .JSON).validate()
            .responseJSON { response in
                switch response.result {
                case .Success(let data):
                    let json = JSON(data)
                    let id = json["id"]
                    if id.error == nil {
                        let employer_id = json["employer_id"].int!
                        let name = json["name"].string!
                        let password = json["password_digest"].string!
                        let e : Employee = Employee(employer_id: employer_id, name: name, password: password)
                        e.id = json["id"].int!
                        self.addressService.getAddressesByEmployerId(employer_id: employer_id, completionHandler: addressCompletionHandler, failureCompletionHandler: wrongLoginHandler)
                        employeeCompletionHandler(e as Employee)
                    } else {
                        wrongLoginHandler()
                    }
                    break
                case .Failure(let error):
                    wrongLoginHandler()
                    break
                }
            }
        
    }
    
        
}


