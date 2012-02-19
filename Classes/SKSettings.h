//
//  SKSettings.h
//  StackKit
//
//  Created by Dave DeLong on 2/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StackKit/SKTypes.h>

enum {
    SKAuthenticationScopeDefault = 0,
    SKAuthenticationScopeReadInbox = 1 << 0,
    SKAuthenticationScopeNoExpiration = 1 << 1
};

typedef NSInteger SKAuthenticationScope;

@interface SKSettings : NSObject

+ (id)sharedSettings;

@property (readonly) BOOL isAuthenticated;
@property (readonly) SKAuthenticationScope authenticationScope;
@property (readonly) NSDate *authenticationExpirationDate;
@property (readonly) NSString *accessToken;

@property (copy) NSString *clientID;

// since this presents a UI, it should only be invoked from the main thread
// the context may be an NSWindow, a UIViewController, or nil
- (void)requestAuthenticationScope:(SKAuthenticationScope)scope presentingFromContext:(id)context completionHandler:(SKErrorHandler)handler;

- (void)requestUsersForAuthenticatedUser:(SKRequestHandler)handler;

@end
