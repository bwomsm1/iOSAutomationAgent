//
//  DataStream.h
//  AutomationKit
//
//  Created by Boaz Warshawsky on 10/09/2017.
//  Copyright © 2017 Boaz Warshawsky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//=========================================================================
// Public Interface
//=========================================================================
@interface DataStream : NSObject


/** @brief Return singleton by stream name
 *  @param[in] name - Stream name
 *  @return Stream object
 */
+ (DataStream*) stream:(NSString*)name;

/** @brief Convert a dictionary into a json string
 *  @param[in] dictionary - Dictionary object
 *  @return String result
 */
+ (NSString*) json:(NSDictionary*)dictionary;

/** @brief Return singleton by stream name
 *  @note the name is unique per collection
 *  @param[in] name - Stream name
 *  @param[in,out] collection - Dictionary to contain stream
 *  @return Stream object
 */
+ (DataStream*) stream:(NSString*)name collection:(NSMutableDictionary* __strong *)collection;

/** @brief Check if the stream is empty
 *  @return YES if the stream is empty
 */
- (BOOL) isEmpty;

/** @brief Reset the stream
 */
- (void) empty;

/** @brief Retrieve root dictionary
 *  @return Root dictionary
 */
- (NSDictionary*) root;

/** @brief Retrieve root dictionary as json formatted string
 *  @return String object
 */
- (NSString*) json;

/** @brief Add an array
 *  @param[in] array - Array object
 *  @param[in] key - Dictionary key
 */
- (void) addArray:(NSArray*)array key:(NSString*)key;

/** @brief Add a dictionary
 *  @param[in] dictionary - Dictionary object
 *  @param[in] key - Dictionary key
 */
- (void) addDictionary:(NSDictionary*)dictionary key:(NSString*)key;

/** @brief Add dictionary entries
 *  @param[in] dictionary - Dictionary object
 */
- (void) addDictionaryEntries:(NSDictionary*)dictionary;

/** @brief Add a color
 *  @param[in] color - Color object
 *  @param[in] key - Dictionary key
 */
- (void) addColor:(UIColor*)color key:(NSString*)key;

/** @brief Add a boolean
 *  @param[in] value - Boolean value
 *  @param[in] key - Dictionary key
 */
- (void) addBool:(BOOL)value key:(NSString*)key;

/** @brief Add a boolean formatted as a string
 *  @param[in] value - Boolean value
 *  @param[in] key - Dictionary key
 */
- (void) addBoolAsString:(BOOL)value key:(NSString*)key;

/** @brief Add an integer
 *  @param[in] value - Integer value
 *  @param[in] key - Dictionary key
 */
- (void) addInteger:(NSInteger)value key:(NSString*)key;

/** @brief Add an integer formatted as a string
 *  @param[in] value - Integer value
 *  @param[in] key - Dictionary key
 */
- (void) addIntegerAsString:(NSInteger)value key:(NSString*)key;

/** @brief Add a string
 *  @param[in] string - String object
 *  @param[in] key - Dictionary key
 */
- (void) addString:(NSString*)string key:(NSString*)key;

/** @brief Add a string with a default if string is empty
 *  @param[in] string - String object
 *  @param[in] key - Dictionary key
 *  @param[in] defaultValue - Default value
 */
- (void) addString:(NSString*)string key:(NSString*)key defaultValue:(NSString*)defaultValue;

/** @brief Add a float
 *  @param[in] value - Float value
 *  @param[in] key - Dictionary key
 */
- (void) addFloat:(float)value key:(NSString*)key;

/** @brief Add a float formatted as a string
 *  @param[in] value - Integer value
 *  @param[in] key - Dictionary key
 */
- (void) addFloatAsString:(float)value key:(NSString*)key;

/** @brief Add a double
 *  @param[in] value - Double value
 *  @param[in] key - Dictionary key
 */
- (void) addDouble:(double)value key:(NSString*)key;

/** @brief Add a double formatted as a string
 *  @param[in] value - Double value
 *  @param[in] key - Dictionary key
 */
- (void) addDoubleAsString:(double)value key:(NSString*)key;

/** @brief Add number
 *  @param[in] value - Number value
 *  @param[in] key - Dictionary key
 */
- (void) addNumber:(NSNumber*)value key:(NSString*)key;

/** @brief Add object
 *  @param[in] object - Object value
 *  @param[in] key - Dictionary key
 */
- (void) addObject:(NSObject*)object key:(NSString*)key;

/** @brief Push all subsequent entries inside a sub dictionary
 *  @param[in] key - Dictionary key
 */
- (void) beginDictionary:(NSString*)key;

/** @brief Push all subsequent entries inside a sub array
 *  @param[in] key - Dictionary key
 */
- (void) beginArray:(NSString*)key;

/** @brief End the current sub dictionary and set parent as current dictionary
 */
- (void) end;

/** @brief Validate an object
 *  @param[in] object - Object to validate
 *  @param[in] key - Dictionary key
 */
- (bool) validate:(NSObject*)object key:(NSString*)key;

@end
