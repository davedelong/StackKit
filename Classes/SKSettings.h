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

// Must be called from the main thread
// The context may be an NSWindow, a UIViewController, or nil
- (void)requestAuthenticationScope:(SKAuthenticationScope)scope presentingFromContext:(id)context completionHandler:(SKErrorHandler)handler;

// Invalidation causes the access token to be destroyed.
// Subsequent attempts to request authentication should not require the user to re-approve access
- (void)requestAccessInvalidationWithCompletionHandler:(SKErrorHandler)handler;

// Deauthorization causes the access token to be destoryed and the app to be removed from the user's list of approved apps
// Subsequent attempts to request authentication will require the user to re-approve access
- (void)requestAccessDeauthorizationWithCompletionHandler:(SKErrorHandler)handler;

- (void)requestUsersForAuthenticatedUser:(SKRequestHandler)handler;

@end
