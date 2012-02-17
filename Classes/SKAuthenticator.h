//
//  SKAuthenticator.h
//  StackKit
//
//  Created by Dave DeLong on 2/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
    SKAuthenticationOptionDefault = 0,
    SKAuthenticationOptionAccessInbox = 1 << 0,
    SKAuthenticationOptionNoExpiry = 1 << 1
};

typedef NSUInteger SKAuthenticationOption;
typedef void(^SKAuthenticationHandler)(NSError *);

@interface SKAuthenticator : NSObject

/**
 if "window" is an NSWindow, then a sheet will be displayed
 if "window" is a UIViewController, then a modal viewController will be presented
 if "window" is nil, then a panel (Mac) or a modal viewController (iOS) will be presented
 anything else will fail
 **/
+ (void)requestAuthenticationWithOptions:(SKAuthenticationOption)options presentingFrom:(id)window completionHandler:(SKAuthenticationHandler)handler;

@end
