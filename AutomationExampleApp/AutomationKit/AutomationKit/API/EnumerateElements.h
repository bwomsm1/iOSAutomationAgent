//
//  EnumerateElements.h
//  AutomationKit
//
//  Created by Boaz Warshawsky on 10/09/2017.
//  Copyright © 2017 Boaz Warshawsky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataStream.h"
#import "../HttpServer/JSONRPCMethods.h"


//=========================================================================
// Public Protocols
//=========================================================================
@protocol AutomationElementView <NSObject>

- (BOOL) enumerateViewElements;

@end


//=========================================================================
// Public Interface
//=========================================================================
@interface EnumerateElements : NSObject <JSONRPCMethodHandler>
+ (DataStream*) stream;
@end
