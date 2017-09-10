//
//  JSONRPCMethods.m
//  AutomationKit
//
//  Created by Boaz Warshawsky on 07/09/2017.
//  Copyright © 2017 Boaz Warshawsky. All rights reserved.
//



#import "JSONRPCMethods.h"

@implementation JSONRPCMethods

NSMutableDictionary *requestHandlers = nil;

-(void)registerMethod:(NSString *)method RequestHandler:(id<JSONRPCMethodHandler>)handler
{
    if (requestHandlers)
    {
        requestHandlers[method] = handler;
    }
}

-(BOOL)methodSupported:(NSString *)method
{
    if (requestHandlers[method] != nil) {
        return YES;
    }
    
    return NO;
}

-(NSString *)executeMethod:(NSString *)method WithParams:(NSArray *)params
{
    id<JSONRPCMethodHandler> methodHandler = requestHandlers[method];
    NSString *responseString = nil;
    
    if (methodHandler)
    {
        responseString = [methodHandler executeWithParams:params];
    }
    
    return responseString;
}

+ (JSONRPCMethods *)sharedJSONRPCMethods
{
    static JSONRPCMethods *sharedJSONRPCMethods = nil;
    
    if (sharedJSONRPCMethods == nil)
    {
        sharedJSONRPCMethods = [[JSONRPCMethods alloc] init];
        
        if (sharedJSONRPCMethods)
        {
            requestHandlers = [[NSMutableDictionary alloc] init];
        }
    }
    
    return sharedJSONRPCMethods;
}

@end
