//
//  Employee.swift
//  Simplifi
//
//  Created by Jared Korotzer on 3/14/16.
//  Copyright © 2016 Simplifi. All rights reserved.
//

import Foundation
class Employee {
    
    var id: Int
    var employer_id:Int
    var name:String
    var password:String
    var first_name: String?
    var last_name: String?
    var job_title: String?
    var company_name: String?
    var hours_per_week: Double?
    var wage_per_hour: Double?
    var notes: String?
    
    init(employer_id:Int, name:String, password:String, id: Int) {
        self.employer_id = employer_id
        self.name = name
        self.password = password
        self.id = id
    }
    
    init(json: JSON) {
        if json["employee"].exists() {
            let id = json["employee"]["id"].int!
            let employer_id = json["employee"]["employer_id"].int!
            let name = json["employee"]["name"].string!
            let password = json["employee"]["password_digest"].string!
            self.id = id
            self.employer_id = employer_id
            self.name = name
            self.password = password
            self.first_name = json["employee"]["first_name"].string ?? ""
            self.last_name = json["employee"]["last_name"].string ?? ""
            self.job_title = json["employee"]["job_title"].string ?? ""
            self.company_name = json["employee"]["company_name"].string ?? ""
            self.hours_per_week = Double(json["employee"]["hours_per_week"].string!) ?? 0.0
            self.wage_per_hour = Double(json["employee"]["wage_per_hour"].string!) ?? 0.0
            self.notes = json["employee"]["notes"].string ?? ""
        } else {
            let id = json["id"].int!
            let employer_id = json["employer_id"].int!
            let name = json["name"].string!
            let password = json["password_digest"].string!
            self.id = id
            self.employer_id = employer_id
            self.name = name
            self.password = password
            self.first_name = json["first_name"].string ?? ""
            self.last_name = json["last_name"].string ?? ""
            self.job_title = json["job_title"].string ?? ""
            self.company_name = json["company_name"].string ?? ""
            self.hours_per_week = Double(json["hours_per_week"].string ?? "") ?? 0.0
            self.wage_per_hour = Double(json["wage_per_hour"].string ?? "") ?? 0.0
            self.notes = json["notes"].string ?? ""
        }
    }
}