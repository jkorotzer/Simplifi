//
//  Global.swift
//  Simplifi
//
//  Created by Jared on 3/29/16.
//  Copyright © 2016 Jared. All rights reserved.
//

import Foundation
import UIKit

func SimplifiColor() -> UIColor {
    return UIColor(red: 29.0 / 255.0, green: 94.0 / 255.0, blue: 156.0 / 255.0, alpha: 1.0)
}

/*func getIFAddresses() -> [String] {
    var addresses = [String]()

    // Get list of all interfaces on the local machine:
    var ifaddr : UnsafeMutablePointer<ifaddrs> = nil
    if getifaddrs(&ifaddr) == 0 {

    // For each interface ...
        for (var ptr = ifaddr; ptr != nil; ptr = ptr.memory.ifa_next) {
            let flags = Int32(ptr.memory.ifa_flags)
            var addr = ptr.memory.ifa_addr.memory

            // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
            if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {

                // Convert interface address to a human readable string:
                var hostname = [CChar](count: Int(NI_MAXHOST), repeatedValue: 0)
                    if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),
                        nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                            if let address = String.fromCString(hostname) {
                            addresses.append(address)
                            }
                    }
            }
        }
    }
    freeifaddrs(ifaddr)
}

return addresses
}*/

/*let jsonObj = ["employee":["employer_id":e.employer_id, "name":e.name, "password": e.password]]
let request = NSMutableURLRequest(URL: NSURL(string: url)!)
let session = NSURLSession.sharedSession()

request.HTTPMethod = "POST"
request.addValue("application/json", forHTTPHeaderField: "Content-Type")
request.addValue("application/json", forHTTPHeaderField: "Accept")


do {
request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(jsonObj, options: [])
}
catch {
print(error)
request.HTTPBody = nil
}

let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
guard error == nil
else
{
return
}
let json: NSDictionary?
do {
json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableLeaves) as? NSDictionary
print(json)
} catch let dataError {
print(dataError)
let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
print("Error could not parse JSON: '\(jsonStr)'")
return
}
if let parseJSON = json {
let success = parseJSON["success"] as? Int
print("Succes: \(success)")
}
else {
let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
print("Error could not parse JSON: \(jsonStr)")
}

})

task.resume()*/