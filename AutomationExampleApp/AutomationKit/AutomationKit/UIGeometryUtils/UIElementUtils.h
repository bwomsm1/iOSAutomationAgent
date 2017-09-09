//
//  UIElementUtils.h
//  AutomationKit
//
//  Created by Boaz Warshawsky on 07/09/2017.
//  Copyright © 2017 Boaz Warshawsky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

//=========================================================================
// Public Interface
//=========================================================================
@interface UIElementUtils : NSObject
+ (bool) getBoolean:(NSDictionary*)dict name:(NSString*)name value:(BOOL*)value;
+ (bool) getInteger:(NSDictionary*)dict name:(NSString*)name value:(NSInteger*)value;
+ (bool) getDouble:(NSDictionary*)dict name:(NSString*)name value:(double*)value;
+ (bool) getString:(NSDictionary*)dict name:(NSString*)name value:(NSString**)value;
+ (bool) getDict:(NSDictionary*)dict name:(NSString*)name value:(NSDictionary**)value;
+ (bool) getArray:(NSDictionary*)dict name:(NSString*)name value:(NSArray**)value;
+ (bool) getPosition:(NSDictionary*)dict name:(NSString*)name value:(CGPoint*)value;
@end
