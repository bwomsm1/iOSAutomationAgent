//
//  JSONRPCRequest.h
//  AutomationKit
//
//  Created by Boaz Warshawsky on 07/09/2017.
//  Copyright © 2017 Boaz Warshawsky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONRPCRequest : NSObject

@property (nonatomic, readonly) NSString *version;
@property (nonatomic, readonly) id objId;
@property (nonatomic, readonly) NSString *method;
@property (nonatomic, readonly) NSArray *params;

-(instancetype)initWithRequestBody:(NSData *)body;

@end
