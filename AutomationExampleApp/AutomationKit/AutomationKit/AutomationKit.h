//
//  AutomationKit.h
//  AutomationKit
//
//  Created by Boaz Warshawsky on 05/09/2017.
//  Copyright © 2017 Boaz Warshawsky. All rights reserved.
//

#import <Foundation/Foundation.h>


//=========================================================================
// Public Interface
//=========================================================================
@interface AutomationKit : NSObject

+ (AutomationKit*) sharedInstance;
- (void) startAutomationKit;
- (void) closeAutomationKit;

@end
