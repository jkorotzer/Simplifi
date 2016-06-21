//
//  EmployerService.swift
//  Simplifi
//
//  Created by Jared Korotzer on 3/21/16.
//  Copyright © 2016 Jared. All rights reserved.
//

import Foundation
import Alamofire

class EmployerService {
        
    class func requestAllEmployers(completionHandler: ([Employer] -> Void)) {
    
        var employers = [Employer]()
        Alamofire.request(.GET, Settings.viewEmployers)
            .responseJSON {response in
            switch response.result {
            case .Success(let data):
                
                let json = JSON(data)
                for index in 0 ..< json.count{
                    let id = json[index]["id"].int
                    let name = json[index]["name"].string
                    let password = json[index]["password_digest"].string
                    let company_name = json[index]["company_name"].string
                    let e:Employer = Employer(id: id!, name: name!, password: password!, company_name: company_name!)
                    employers.append(e)
                }
                completionHandler(employers as [Employer])
            case .Failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }

    class func requestWithId(id: Int, completionHandler: (Employer -> Void)){
        Alamofire.request(.GET, Settings.viewEmployers+"/"+String(id))
        .responseJSON {response in
            switch response.result {
            case .Success(let data):
                let json = JSON(data)
                if(json.isEmpty) {
                    print("json is empty")
                }
                else {
                    let employer = Employer(id: json["id"].int!, name: json["name"].string!, password: json["password_digest"].string!, company_name: json["company_name"].string!)
                    completionHandler(employer as Employer)
                }
            case .Failure(let error):
                print(error)
                print("json is empty")
            }
        }
    }

    class func signUpEmployer(e: Employer, completionHandler: (Employer -> Void)){
        Alamofire.request(.POST, Settings.viewEmployers, parameters: ["employer":["name": e.name, "password": e.password, "company_name":e.company_name]], encoding: .JSON).responseJSON { (response) in
            switch response.result {
            case .Success(let data):
            let json = JSON(data)
            let employer = Employer(id: json["id"].int!, name: json["name"].string!, password: json["password_digest"].string!, company_name: json["company_name"].string!)
                print("employer done")
                completionHandler(employer as Employer)
            case .Failure(let error):
                print(error)
            }
        }
    }

    class func updateEmployer(id: Int, e :Employer) {
        Alamofire.request(.PUT, Settings.viewEmployers+"/"+String(id), parameters:["employer":["name": e.name, "password_digest":e.password, "company_name": e.company_name]], encoding: .JSON)
    }
}
