//
//  GetIPAddress.m
//  payCheck
//
//  Created by Jared on 2/27/16.
//  Copyright © 2016 Jared. All rights reserved.
//

#import "GetIPAddress.h"
#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#include <ifaddrs.h>
#include <arpa/inet.h>


#import "getgateway.h"
#import <arpa/inet.h>

@implementation GetIPAddress

- (NSString *)getGatewayIP {
    NSString *ipString = nil;
    struct in_addr gatewayaddr;
    int r = getdefaultgateway(&(gatewayaddr.s_addr));
    if(r >= 0) {
        ipString = [NSString stringWithFormat: @"%s",inet_ntoa(gatewayaddr)];
        //NSLog(@"default gateway : %@", ipString );
    } else {
        return @"nil";
    }
    
    return ipString;
    
}


@end