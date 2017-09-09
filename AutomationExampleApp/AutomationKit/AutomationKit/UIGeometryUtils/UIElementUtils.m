//
//  UIElementUtils.m
//  AutomationKit
//
//  Created by Boaz Warshawsky on 07/09/2017.
//  Copyright © 2017 Boaz Warshawsky. All rights reserved.
//

#import "UIElementUtils.h"

@implementation UIElementUtils

+ (bool) getBoolean:(NSDictionary*)dict name:(NSString*)name value:(BOOL*)value {
    bool result = false;
    NSNumber * number = [dict objectForKey:name];
    if(number && [number isKindOfClass:[NSNumber class]]) {
        if(value) {
            *value = [number boolValue];
        }
        result = true;
    }
    return result;
}

+ (bool) getInteger:(NSDictionary*)dict name:(NSString*)name value:(NSInteger*)value {
    bool result = false;
    NSNumber * number = [dict objectForKey:name];
    if(number && [number isKindOfClass:[NSNumber class]]) {
        if(value) {
            *value = [number integerValue];
        }
        result = true;
    }
    return result;
}

+ (bool) getDouble:(NSDictionary*)dict name:(NSString*)name value:(double*)value {
    bool result = false;
    NSNumber * number = [dict objectForKey:name];
    if(number && [number isKindOfClass:[NSNumber class]]) {
        if(value) {
            *value = [number doubleValue];
        }
        result = true;
    }
    return result;
}

+ (bool) getString:(NSDictionary*)dict name:(NSString*)name value:(NSString**)value {
    bool result = false;
    NSString * string = [dict objectForKey:name];
    if(string && [string isKindOfClass:[NSString class]]) {
        if(value) {
            *value = string;
        }
        result = true;
    }
    return result;
}

+ (bool) getDict:(NSDictionary*)dict name:(NSString*)name value:(NSDictionary**)value {
    bool result = false;
    NSDictionary * dictionary = [dict objectForKey:name];
    if(dictionary && [dictionary isKindOfClass:[NSDictionary class]]) {
        if(value) {
            *value = dictionary;
        }
        result = true;
    }
    return result;
}

+ (bool) getArray:(NSDictionary*)dict name:(NSString*)name value:(NSArray**)value {
    bool result = false;
    NSArray * array = [dict objectForKey:name];
    if(array && [array isKindOfClass:[NSArray class]]) {
        if(value) {
            *value = array;
        }
        result = true;
    }
    return result;
}

+ (bool) getPosition:(NSDictionary*)dict name:(NSString*)name value:(CGPoint*)value {
    bool result = false;
    NSArray * array = [dict objectForKey:name];
    if(array && [array isKindOfClass:[NSArray class]]) {
        if([array count]) {
            if(value) {
                value->x = [[array objectAtIndex:0] integerValue];
            }
            result = true;
        }
        if([array count] > 1) {
            if(value) {
                value->y = [[array objectAtIndex:1] integerValue];
            }
        }
    }
    return result;
}

@end
