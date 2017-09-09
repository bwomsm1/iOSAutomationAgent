//
//  JSONRPCRequest.m
//  AutomationKit
//
//  Created by Boaz Warshawsky on 07/09/2017.
//  Copyright © 2017 Boaz Warshawsky. All rights reserved.
//

#import <Foundation/NSJSONSerialization.h>
#import "JSONRPCRequest.h"

@implementation JSONRPCRequest

-(void)initWithData:(NSData *)data
{
    NSError *nserror = nil;
    NSDictionary *requestDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&nserror];
    NSLog(@"AutomationKit: request disctionary = [%@]", requestDict.debugDescription);
    
    _objId = [requestDict objectForKey:@"id"];
    _method = [requestDict objectForKey:@"method"];
    _params = [requestDict objectForKey:@"params"];
    _version = [requestDict objectForKey:@"jsonrpc"];
}

-(instancetype)initWithRequestBody:(NSData *)body
{
    self = [super init];
    
    if (self)
    {
        [self initWithData:body];
    }
    
    return self;
}

@end

