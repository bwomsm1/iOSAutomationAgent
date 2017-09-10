//
//  JSONRPCMethods.h
//  AutomationKit
//
//  Created by Boaz Warshawsky on 07/09/2017.
//  Copyright © 2017 Boaz Warshawsky. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JSONRPCMethodHandler <NSObject>

-(NSString *)executeWithParams:(NSArray *)params;

@end

@interface JSONRPCMethods : NSObject

+ (JSONRPCMethods *) sharedJSONRPCMethods;
- (void) registerMethod:(NSString *)method RequestHandler:(id<JSONRPCMethodHandler>)handler;
- (BOOL) methodSupported:(NSString *)method;
- (NSString *) executeMethod:(NSString *)method WithParams:(NSArray *)params;

@end
