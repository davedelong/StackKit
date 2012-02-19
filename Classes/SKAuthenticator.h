//
//  SKAuthenticator.h
//  StackKit
//
//  Created by Dave DeLong on 2/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StackKit/SKSettings.h>

@interface SKAuthenticator : NSObject

@property (nonatomic, readonly, copy) NSString *accessToken;
@property (readonly, retain) NSDate *expiryDate;
@property (readonly, assign) SKAuthenticationScope scope;

+ (id)sharedAuthenticator;

/**
 if "window" is an NSWindow, then a sheet will be displayed
 if "window" is a UIViewController, then a modal viewController will be presented
 if "window" is nil, then a panel (Mac) or a modal viewController (iOS) will be presented
 anything else will fail
 **/
- (void)requestAuthenticationWithOptions:(SKAuthenticationScope)options presentingFrom:(id)window completionHandler:(SKErrorHandler)handler;

@end
