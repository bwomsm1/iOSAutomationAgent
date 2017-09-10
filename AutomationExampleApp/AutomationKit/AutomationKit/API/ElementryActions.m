//
//  ElementryActions.m
//  AutomationKit
//
//  Created by Boaz Warshawsky on 07/09/2017.
//  Copyright © 2017 Boaz Warshawsky. All rights reserved.
//

#import "ElementryActions.h"
#import "UIView-KIFAdditions.h"
#import "UIElementUtils.h"


//=========================================================================
// Private Interface
//=========================================================================
@interface ElementryActions (Private)
- (bool) tap:(UIWindow*)window params:(NSDictionary*)params;
@end


//=========================================================================
// Public Implementation
//=========================================================================
@implementation ElementryActions
- (NSString*) executeWithParams:(NSArray *)params {
    
    NSString* jsonString = @"null";
    NSDictionary * methodParams = (NSDictionary*) params;
    
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    
    if(window) {
        /* Check if action */
        NSString * methodName = [methodParams objectForKey:@"action"];
        if(methodName) {
            
            /* Check methods */
            if([methodName isEqualToString:@"tap"]) {
                [self tap:window params:methodParams];
            }
//            else if([methodName isEqualToString:@"swipe"]) {
//                [self swipe:window params:methodParams];
//            }
//            else if([methodName isEqualToString:@"zoom"]) {
//                [self zoom:window params:methodParams];
//            }
//            else if([methodName isEqualToString:@"pinch"]) {
//                [self pinch:window params:methodParams];
//            }
//            else if([methodName isEqualToString:@"type"]) {
//                [self type:window params:methodParams];
//            }
//            else if([methodName isEqualToString:@"special-key"]) {
//                [self specialKey:window params:methodParams];
//            }
//            else if([methodName isEqualToString:@"keyboard"]) {
//                [self keyboard:window params:methodParams];
//            }
//            else if([methodName isEqualToString:@"stop-app"]) {
//                [self stopApp:window params:methodParams];
//            }
//            else if([methodName isEqualToString:@"pause-app"]) {
//                [self pauseApp:window params:methodParams];
//            }
//            else if([methodName isEqualToString:@"focus"]) {
//                [self focus:window params:methodParams];
//            }
//            else if([methodName isEqualToString:@"sleep"]) {
//                [self sleep:window params:methodParams];
//            }
//            else if([methodName isEqualToString:@"text"]) {
//                [self text:window params:methodParams];
//            }
//            else if([methodName isEqualToString:@"query"]) {
//                [self query:window params:methodParams];
//            }
            else {
                jsonString = [NSString stringWithFormat:@"Cannot find method %@", methodName];
            }
        }
    }
    else {
        jsonString = @"Cannot find window in application";
    }
    
    return jsonString;
}

@end


//=========================================================================
// Private Implementation
//=========================================================================
@implementation ElementryActions (Private)

- (bool) tap:(UIWindow*)window params:(NSDictionary*)params {
    bool result = false;
    NSString * elementId = nil, * elementLabel = nil;
    NSInteger tapCount = 1, duration = 0, fingerCount = 1;
    CGPoint tapPoint = CGPointMake(window.frame.size.width * 0.5f, window.frame.size.height * 0.5f);
    
    [UIElementUtils getPosition:params name:@"pos" value:&tapPoint];
    [UIElementUtils getInteger:params name:@"tap-count" value:&tapCount];
    [UIElementUtils getInteger:params name:@"duration" value:&duration];
    [UIElementUtils getInteger:params name:@"finger-count" value:&fingerCount];
    [UIElementUtils getString:params name:@"id" value:&elementId];
    [UIElementUtils getString:params name:@"label" value:&elementLabel];
    UIView * view = [self findTopView:window screenPoint:tapPoint rootOnly:NO];
    
    if (view) {
        if (fingerCount == 1) {
            if(duration) {
                [view longPressAtPoint:tapPoint duration:duration/1000];
            } else {
                for(NSInteger tapIndex = 0; tapIndex < tapCount; tapIndex++) {
                    [view tapAtPoint:tapPoint];
                }
            }
            result = true;
            
        } else if(fingerCount == 2) {
            [view twoFingerTapAtPoint:tapPoint];
            result = true;
        }
    }
    return result;
}

- (UIView*) findTopView:(UIView*)view screenPoint:(CGPoint)screenPoint rootOnly:(BOOL)rootOnly {
    UIView * result = nil, * child = nil;
    if(!rootOnly) {
        result = [view hitTest:screenPoint withEvent:nil];
    }
    else {
        for(child in [[view subviews] reverseObjectEnumerator]) {
            if (child.isHidden || child.alpha == 0) {
                continue;
            }
            if (!child.isUserInteractionEnabled) {
                continue;
            }
            if (![child isKindOfClass:[UIControl class]] && ![child hitTest:screenPoint withEvent:nil]) {
                continue;
            }
            CGRect viewRectInScreen = [child convertRect:view.bounds toView:nil];
            if(!CGRectContainsPoint(viewRectInScreen, screenPoint)) {
                continue;
            }
            result = child;
            break;
        }
    }
    return result;
}

@end
