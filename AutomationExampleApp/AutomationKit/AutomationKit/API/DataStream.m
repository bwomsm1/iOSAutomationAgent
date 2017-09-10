//
//  DataStream.m
//  AutomationKit
//
//  Created by Boaz Warshawsky on 10/09/2017.
//  Copyright © 2017 Boaz Warshawsky. All rights reserved.
//

#import "DataStream.h"

//=========================================================================
// Global Class Defines
//=========================================================================
NSMutableDictionary * s_streams = nil;


//=========================================================================
// Public Implementation
//=========================================================================
@implementation DataStream {
    NSMutableDictionary * rootNode;
    NSMutableArray * contexts;
    id currentContext;
    NSString * streamName;
}

+ (DataStream*) stream:(NSString*)name {
    return [self stream:name collection:&s_streams];
}

+ (NSString*) json:(NSDictionary*)dictionary {
    NSError * error = nil;
    NSString * jsonString = nil;
    NSData * jsonData = nil;
    jsonData = [NSJSONSerialization dataWithJSONObject:dictionary
                                               options:NSJSONWritingPrettyPrinted error:&error];
    jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

+ (DataStream*) stream:(NSString*)name collection:(NSMutableDictionary* __strong *)collection {
    DataStream * stream = nil;
    if(!*collection) {
        *collection = [[NSMutableDictionary alloc] init];
    }
    /* Check if stream already exists */
    stream = [*collection objectForKey:name];
    if(!stream) {
        /* Create a stream */
        stream = [[self alloc] initWithName:name];
        [*collection setObject:stream forKey:name];
    }
    return stream;
}

- (instancetype) init {
    if (self = [super init]) {
        rootNode = [[NSMutableDictionary alloc] init];
        contexts = [[NSMutableArray alloc] init];
        currentContext = rootNode;
        streamName = @"";
    }
    return self;
}

- (instancetype) initWithName:(NSString*)name {
    if(self = [super init]) {
        rootNode = [[NSMutableDictionary alloc] init];
        contexts = [[NSMutableArray alloc] init];
        currentContext = rootNode;
        streamName = name;
    }
    return self;
}

- (void) empty {
    [rootNode removeAllObjects];
    [contexts removeAllObjects];
    currentContext = rootNode;
}

- (BOOL) isEmpty {
    return ![rootNode count];
}

- (NSDictionary*) root {
    return rootNode;
}

- (NSString*) json {
    return [DataStream json:rootNode];
}

- (bool) validate:(NSObject*)object key:(NSString*)key {
    bool isDictionary = [currentContext isKindOfClass:[NSMutableDictionary class]];
    bool result = false;
    if(!isDictionary || key) {
        if(object) {
            if([object isKindOfClass:[NSDictionary class]] || [object isKindOfClass:[NSArray class]]) {
                result = [NSJSONSerialization isValidJSONObject:object];
                if(!result) {
                    NSLog(@"Stream - Cannot parse %@ as json, key %@, stream %@, context %@", object, key, streamName, currentContext);
                }
            }
            else if([object isKindOfClass:[NSNull class]]) {
                /* Ignore */
            }
            else if([object isKindOfClass:[NSNumber class]]) {
                NSNumber * number = (NSNumber*) object;
                if(isnan([number doubleValue])) {
                    NSLog(@"Stream - Cannot parse %@ as json, key %@, stream %@, context %@", object, key, streamName, currentContext);
                }
                else {
                    /* Valid */
                    result = true;
                }
            }
            else if([object isKindOfClass:[NSString class]]) {
                /* Valid */
                result = true;
            }
            else {
                NSLog(@"Stream - Unsupported class %@ of %@, key %@, stream %@, context %@", [object class], object, key, streamName, currentContext);
            }
        }
        /* No error if passing nil object */
    }
    else {
        NSLog(@"Stream - Cannot add %@ with an empty key, stream %@, context %@", object, streamName, currentContext);
    }
    return result;
}

- (void) addArray:(NSArray*)array key:(NSString*)key {
    if([self validate:array key:key]) {
        [self addObject:array key:key];
    }
}

- (void) addDictionary:(NSDictionary*)dictionary key:(NSString*)key {
    if([self validate:dictionary key:key]) {
        [self addObject:dictionary key:key];
    }
}


- (void) addDictionaryEntries:(NSDictionary*)dictionary {
    for(id key in dictionary) {
        id entry = [dictionary objectForKey:key];
        if([self validate:entry key:key]) {
            [self addObject:entry key:key];
        }
    }
}

- (void) addColor:(UIColor*)color key:(NSString*)key {
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    NSString *string = [NSString stringWithFormat:@"%02X%02X%02X", (int)(r * 255), (int)(g * 255), (int)(b * 255)];
    if([self validate:string key:key]) {
        [self addObject:string key:key];
    }
}

- (void) addBool:(BOOL)value key:(NSString*)key {
    NSNumber * number = [[NSNumber alloc] initWithBool:value];
    if([self validate:number key:key]) {
        [self addObject:number key:key];
    }
}

- (void) addBoolAsString:(BOOL)value key:(NSString*)key {
    NSNumber * number = [[NSNumber alloc] initWithBool:value];
    if([self validate:number key:key]) {
        [self addObject:[number boolValue] ? @"true" : @"false" key:key];
    }
}

- (void) addInteger:(NSInteger)value key:(NSString*)key {
    NSNumber * number = [[NSNumber alloc] initWithInteger:value];
    if([self validate:number key:key]) {
        [self addObject:number key:key];
    }
}

- (void) addIntegerAsString:(NSInteger)value key:(NSString*)key
{
    NSNumber * number = [[NSNumber alloc] initWithInteger:value];
    if([self validate:number key:key]) {
        [self addObject:[number stringValue] key:key];
    }
}

- (void) addString:(NSString*)string key:(NSString*)key {
    if([self validate:string key:key]) {
        [self addObject:string key:key];
    }
}

- (void) addString:(NSString*)string key:(NSString*)key defaultValue:(NSString*)defaultValue {
    if([self validate:string key:key]) {
        [self addObject:string key:key];
    }
    else if(key) {
        [self addString:defaultValue key:key];
    }
}

- (void) addFloat:(float)value key:(NSString*)key {
    NSNumber * number = [[NSNumber alloc] initWithFloat:value];
    if([self validate:number key:key]) {
        [self addObject:number key:key];
    }
}

- (void) addFloatAsString:(float)value key:(NSString*)key {
    NSNumber * number = [[NSNumber alloc] initWithFloat:value];
    if([self validate:number key:key]) {
        [self addObject:[number stringValue] key:key];
    }
}

- (void) addDouble:(double)value key:(NSString*)key {
    NSNumber * number = [[NSNumber alloc] initWithDouble:value];
    if([self validate:number key:key]) {
        [self addObject:number key:key];
    }
}

- (void) addDoubleAsString:(double)value key:(NSString*)key {
    NSNumber * number = [[NSNumber alloc] initWithDouble:value];
    if([self validate:number key:key]) {
        [self addObject:[number stringValue] key:key];
    }
}

- (void) addNumber:(NSNumber *)value key:(NSString *)key {
    if([self validate:value key:key]) {
        [self addObject:value key:key];
    }
}

- (void) addObject:(NSObject*)object key:(NSString*)key {
    if([currentContext isKindOfClass:[NSMutableArray class]]) {
        NSMutableArray * array = currentContext;
        [array addObject:object];
    }
    else if([currentContext isKindOfClass:[NSMutableDictionary class]]) {
        NSMutableDictionary * dictionary = currentContext;
        if(key) {
            [dictionary setObject:object forKey:key];
        }
        else {
            NSLog(@"Cannot add %@ with an empty key, stream %@, content %@", object, streamName, currentContext);
        }
    }
}

- (void) beginDictionary:(NSString*)key {
    NSMutableDictionary * dictionary = [[NSMutableDictionary alloc] init];
    [self addObject:dictionary key:key];
    [contexts addObject:dictionary];
    currentContext = dictionary;
}

- (void) beginArray:(NSString*)key {
    NSMutableArray * array = [[NSMutableArray alloc] init];
    [self addObject:array key:key];
    [contexts addObject:array];
    currentContext = array;
}

- (void) end {
    [contexts removeLastObject];
    currentContext = [contexts lastObject];
    if(!currentContext) {
        currentContext = rootNode;
    }
}

@end
