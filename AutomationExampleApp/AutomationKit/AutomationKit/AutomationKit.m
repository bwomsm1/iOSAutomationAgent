//
//  AutomationKit.m
//  AutomationKit
//
//  Created by Boaz Warshawsky on 05/09/2017.
//  Copyright © 2017 Boaz Warshawsky. All rights reserved.
//

#import "AutomationKit.h"
#import "JSONRPCMethods.h"
#import "ElementryActions.h"
#import "EnumerateElements.h"
#include "HTTPServer.h"
#import "JSONRPCResponse.h"
#import "AppTextFileResponse.h"

//=========================================================================
// Private Interface
//=========================================================================
@interface AutomationKit (Private)
- (void) setupServices;
@end

//=========================================================================
// Public Implementation
//=========================================================================
@implementation AutomationKit

HTTPServer *httpServer_ = nil;

+ (AutomationKit*) sharedInstance {
    static AutomationKit *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[AutomationKit alloc] init];
    });
    return instance;
}


- (void) startAutomationKit {
    httpServer_ = [HTTPServer sharedHTTPServer];
    [self setupServices];
    [httpServer_ start];
}
//+ (void) startAutomationServer:(short)port {
//    
//    
//    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        
//        [NSThread sleepForTimeInterval:10];
//        
//        UIWindow *window = [[UIApplication sharedApplication].delegate window];
//        
//        
//    });
//    
//}

- (void) closeAutomationKit {
    if (httpServer_ && ([httpServer_ state] == SERVER_STATE_STARTING || [httpServer_ state] == SERVER_STATE_RUNNING)) {
        [httpServer_ stop];
    }
}


@end


//=========================================================================
// Private Implementation
//=========================================================================
@implementation AutomationKit (Private)

- (void) setupServices {
    [JSONRPCResponse class];
    [AppTextFileResponse class];
    [[JSONRPCMethods sharedJSONRPCMethods] registerMethod:@"elementryActions" RequestHandler:[[ElementryActions alloc] init]];
    [[JSONRPCMethods sharedJSONRPCMethods] registerMethod:@"enumerateElements" RequestHandler:[[EnumerateElements alloc] init]];
}

@end



