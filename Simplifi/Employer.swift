//
//  Employer.swift
//  payCheck
//
//  Created by Andrew Moeckel on 3/21/16.
//  Copyright © 2016 Jared. All rights reserved.
//

import Foundation
class Employer {
    
    var id:Int
    var name:String
    var password: String
    var company_name: String
    
    init(id: Int, name: String, password: String, company_name:String) {
        self.id = id
        self.name = name
        self.password = password
        self.company_name = company_name
    }
    
}
