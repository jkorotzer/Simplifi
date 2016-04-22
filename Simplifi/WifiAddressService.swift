//
//  WifiAddressService.swift
//  Simplifi
//
//  Created by Jared on 4/11/16.
//  Copyright © 2016 Jared. All rights reserved.
//

import Foundation
import Alamofire

class WifiAddressService {
    
    private var url = Settings().viewEmployers
    
    func getAddressesByEmployerId(employer_id employer_id: Int, completionHandler: ([String] -> Void), failureCompletionHandler: () -> Void) {
        let currentUrl = url + "/\(employer_id)/addresses"
        var addresses = [String]()
        Alamofire.request(.GET, currentUrl)
            .responseJSON {response in
                switch response.result {
                case .Success(let data):
                    let json = JSON(data)
                    for var index = 0; index < json.count; ++index {
                        let address = json[index]["address"].string
                        addresses.append(address!)
                    }
                    completionHandler(addresses as [String])
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                }
        }
    }
    
}