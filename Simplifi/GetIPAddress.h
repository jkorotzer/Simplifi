
//
//  GetIPAddress.h
//  payCheck
//
//  Created by Jared on 2/27/16.
//  Copyright © 2016 Jared. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <ifaddrs.h>
#include <arpa/inet.h>

@interface GetIPAddress : NSObject

- (NSString *)getGatewayIP;

@end
