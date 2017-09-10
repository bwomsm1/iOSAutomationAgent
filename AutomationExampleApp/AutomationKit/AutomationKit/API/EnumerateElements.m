//
//  EnumerateElements.m
//  AutomationKit
//
//  Created by Boaz Warshawsky on 10/09/2017.
//  Copyright © 2017 Boaz Warshawsky. All rights reserved.
//

#import "EnumerateElements.h"
#import <UIKit/UIKit.h>


//=========================================================================
// Public Implementation
//=========================================================================
@implementation EnumerateElements


+ (DataStream*) stream {
    DataStream * stream = [DataStream stream:@"EnumerateElements"];
    return stream;
}

- (NSString *) executeWithParams:(NSArray *)params {
    DataStream * stream = [EnumerateElements stream];
    NSString* jsonString = nil;
    
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    BOOL hasWindow = window != nil;
    
    [stream empty];
    
    if (hasWindow) {
        [stream beginArray:@"elements"];
        [stream beginDictionary:nil];
        [stream end];
        [self enumerateElements: window];
        [stream end];
    }
    NSLog(@"executeWithParams: hasWindow=%i", hasWindow);
    
    jsonString = [stream json];
    return jsonString;
}

- (BOOL) isViewVisible:(UIView*)view {
    if(view == nil || view.hidden == YES || view.alpha == 0) {
        return NO;
    }
    return YES;
}

- (BOOL) isViewOnScreen:(UIView*)theView {
    if([self isViewVisible:theView] == NO){
        return NO;
    }
    
    UIView *view = theView.superview;
    if([view isKindOfClass:[UITableView class]]){//trick to overcome the weird UITableViewWrapperView class issues
        return YES;
    }
    UIView *topmostView = [[UIApplication sharedApplication] keyWindow];
    
    CGRect viewRectInWindow = [theView convertRect:theView.bounds toView:nil];
    if(CGRectIntersectsRect(topmostView.bounds, viewRectInWindow) == NO){
        return NO;
    }
    while (view != nil)
    {
        if([view.superview isKindOfClass:[UITableView class]]){//trick to overcome the weird UITableViewWrapperView class issues
            view = view.superview;
            continue;
        }
        
        if((view == nil) || ([self isViewVisible:view] == NO))
            return NO;
        
        
        CGRect rect = [view convertRect:view.bounds toView:nil];
        if(CGRectIntersectsRect(rect, viewRectInWindow) == NO){
            return NO;
        }
        view = view.superview;
    }
    return YES;
}

- (BOOL) enumerateElements:(UIView *)root {
    BOOL result = NO;
    NSArray *subViews = root.subviews;
    
    if([self isViewOnScreen:root]) {
        result = [self enumerateByType:root];
        if(result) {
            for (UIView *view in subViews) {
                [self enumerateElements:view];
            }
        }
    }
    return result;
}

- (void)parseWidget:(UIView*)view name:(NSString*)name
{
    CGPoint basePoint = [view convertPoint:[view bounds].origin toView:nil];
    CGSize size = [view frame].size;
    NSString * text = nil;
    
    DataStream * stream = [EnumerateElements stream];
    
    [stream beginDictionary:nil];
    [stream addString:name key:@"name"];
    [stream addString:@"tap" key:@"action_type"];
    if(view && [view respondsToSelector:@selector(text)]) {
        text = [view performSelector:@selector(text)];
        if(text && [text length]){
            [stream addString:text key:@"title_text"];
        }
    }
    if([view isKindOfClass:[UISlider class]])
    {
        [stream addFloat:[(UISlider  *)view value] key:@"value"];
    } else if([view isKindOfClass:[UIButton class]]){
        [stream addString:[(UIButton  *)view titleLabel].text key:@"title_text"];
    }
    [stream addInteger:basePoint.x key:@"x_pos"];
    [stream addInteger:basePoint.y key:@"y_pos"];
    [stream addInteger:size.width key:@"width"];
    [stream addInteger:size.height key:@"height"];
    [stream addString:view.accessibilityIdentifier key:@"id"];
    //    [stream addDictionaryEntries:[view milestoneAttributes]];
    //    NSString * section = [view findAttribute:@"section"];
    //    [stream addString:section key:@"section"];
    
    [stream end];
}

- (BOOL) enumerateByType:(UIView *)view {
    BOOL result = YES;
    
    if ([[view class] conformsToProtocol:@protocol(AutomationElementView)] ==  YES)
    {
        result = [(id<AutomationElementView>)view enumerateViewElements];
    }
    else if ([view isKindOfClass:[UITextField class]])
    {
        [self parseWidget:view name:@"edit_text"];
    }
    else if ([view isKindOfClass:[UILabel class]])
    {
        [self parseWidget:view name:@"text_view"];
    }
    else if ([view isKindOfClass:[UIButton class]])
    {
        [self parseWidget:view name:@"button_view"];
    }
    else if ([view isKindOfClass:[UIImageView class]])
    {
        [self parseWidget:view name:@"image_view"];
    }
    else if ([view isKindOfClass:[UISlider class]])
    {
        [self parseWidget:view name:@"slider_view"];
    }
    else if ([view isKindOfClass:[UIActivityIndicatorView class]]) {
        [self parseWidget:view name:@"indicator"];
    }
    else if ([view isKindOfClass:[UITableView class]])
    {
        [self parseWidget:view name:@"events_scroller"];
    }
    else if ([view isKindOfClass:[UIScrollView class]])
    {
        [self parseWidget:view name:@"events_scroller"];
    }
    else if ([NSStringFromClass([view class]) isEqualToString:@"ExUIView"])
    {
        [self parseWidget:view name:@"events_scroller"];
    }
    else if ([view isKindOfClass:[UIStackView class]])
    {
        NSArray *subViews = [(UIStackView*)view arrangedSubviews];
        for (UIView *view in subViews) {
            [self enumerateByType:view];
        }
    }
    return result;
}

@end
