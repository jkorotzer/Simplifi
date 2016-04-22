//
//  Employee.swift
//  Temp
//
//  Created by Andrew Moeckel on 3/14/16.
//  Copyright © 2016 payCheck. All rights reserved.
//

import Foundation
class Employee {
    
    var id = Int()
    var employer_id:Int
    var name:String
    var password:String
    
    init(employer_id:Int, name:String, password:String) {
        self.employer_id = employer_id
        self.name = name
        self.password = password
    }
    
    /*func toJSON() -> String{
        return ""
    }*/
}