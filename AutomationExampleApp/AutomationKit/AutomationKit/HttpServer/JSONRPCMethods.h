//
//  JSONRPCMethods.h
//  AutomationKit
//
//  Created by Boaz Warshawsky on 07/09/2017.
//  Copyright © 2017 Boaz Warshawsky. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IJSONRPCMethodHandler <NSObject>

-(NSString *)executeWithParams:(NSArray *)params;

@end

@interface JSONRPCMethods : NSObject

-(void)registerMethod:(NSString *)method RequestHandler:(id<IJSONRPCMethodHandler>)handler;
-(BOOL)methodSupported:(NSString *)method;
-(NSString *)executeMethod:(NSString *)method  WithParams:(NSArray *)params;
+ (JSONRPCMethods *)sharedJSONRPCMethods;

@end
