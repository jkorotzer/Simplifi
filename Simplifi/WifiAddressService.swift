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
    
    class func getAddressesByEmployerId(employer_id employer_id: Int, completionHandler: ([String] -> Void), failureCompletionHandler: () -> Void) {
        let currentUrl = Settings.viewEmployers + "/\(employer_id)/addresses"
        var addresses = [String]()
        Alamofire.request(.GET, currentUrl)
            .responseJSON {response in
                switch response.result {
                case .Success(let data):
                    let json = JSON(data)
                    for index in 0 ..< json.count {
                        let address = json[index]["address"].string
                        addresses.append(address!)
                    }
                    completionHandler(addresses as [String])
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                }
        }
    }
    
    class func postAddresses(addresses: [String], employer_id: Int, completionHandler: () -> Void, errorHandler: () -> Void) {
        let currentUrl = Settings.viewEmployers + "/\(employer_id)/addresses"
        let numTimes = addresses.count
        var count = 0
        for address in addresses {
            Alamofire.request(.POST, currentUrl, parameters: ["address":["address":address]], encoding: .JSON).responseJSON { (response) in
                switch response.result {
                case .Success(_):
                    count = count + 1
                    print(count)
                    if count == numTimes {
                        completionHandler()
                    }
                case .Failure(_):
                    count = count + 1
                    if count == numTimes {
                        errorHandler()
                    }
                }
            }
        }
    }
    
}