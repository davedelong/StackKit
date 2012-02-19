//
//  SKAuthenticator.m
//  StackKit
//
//  Created by Dave DeLong on 2/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SKAuthenticator.h"
#import <StackKit/SKMacros.h>
#import <StackKit/SKConstants.h>
#import <StackKit/SKTypes.h>
#import <StackKit/SKAuthenticatorController.h>


#if StackKitMac
#import <AppKit/AppKit.h>
#elif StackKitMobile
#import <UIKit/UIKit.h>
#endif

NSString *const SKAuthenticationAccessTokenKey = @"access_token";
NSString *const SKAuthenticationExpiresKey = @"expires";

@interface SKAuthenticator ()

- (id)_init;

@property (assign,getter=isPresenting) BOOL presenting;
@property (copy) SKErrorHandler handler;
@property (assign) SKAuthenticationScope scope;
@property (assign) id context;

@property (nonatomic, copy) NSString *accessToken;
@property (retain) NSDate *expiryDate;

- (void)present;

@end

@implementation SKAuthenticator {
    SKAuthenticatorController *_controller;
}

+ (id)sharedAuthenticator {
    static dispatch_once_t onceToken;
    static SKAuthenticator *authenticator = nil;
    dispatch_once(&onceToken, ^{
        authenticator = [[SKAuthenticator alloc] _init];
    });
    return authenticator;
}

- (void)requestAuthenticationWithOptions:(SKAuthenticationScope)options presentingFrom:(id)window completionHandler:(SKErrorHandler)handler {
    if ([self isPresenting]) {
        NSError *error = [NSError errorWithDomain:SKErrorDomain code:SKErrorCodeAuthenticationInProgress userInfo:nil];
        handler(error);
    } else {
        [self setHandler:handler];
        [self setScope:options];
        [self setContext:window];
        
        [self present];
    }
}

@synthesize presenting=_presenting;
@synthesize handler=_handler;
@synthesize scope=_scope;
@synthesize context=_context;
@synthesize accessToken=_accessToken;
@synthesize expiryDate=_expiryDate;

- (NSString *)accessToken {
    if (_expiryDate && [_expiryDate timeIntervalSinceReferenceDate] < [NSDate timeIntervalSinceReferenceDate]) {
        // the token has expired
        [self setAccessToken:nil];
        return nil;
    }
    return _accessToken;
}

- (id)_init {
    self = [super init];
    if (self) {
        _presenting = NO;
        _controller = [[SKAuthenticatorController alloc] init];
    }
    return self;
}

- (void)present {
    BOOL contextIsValid = NO;
    
#if StackKitMac
    
    Class nswindow = NSClassFromString(@"NSWindow");
    contextIsValid = (_context == nil || nswindow == nil || [_context isKindOfClass:nswindow]);
    
#elif StackKitMobile
    
    Class uiviewcontroller = NSClassFromString(@"UIViewController");
    contextIsValid = (_context == nil || uiviewcontroller == nil || [_context isKindOfClass:uiviewcontroller]);
    
#endif
    
    NSAssert(contextIsValid, @"Invalid context: %@", _context);
    
    _presenting = YES;
    
#if StackKitMac
    
    [_controller presentInContext:_context scope:_scope handler:^(NSInteger code) {
        [self _invokeHandler];        
        _presenting = NO;
    }];
    
#elif StackKitMobile
    
#endif
    
}

- (void)_invokeHandler {
    NSError *e = [_controller error];
    
    if (e == nil) {
        NSDictionary *information = [_controller accessInformation];
        [self setAccessToken:[information objectForKey:SKAuthenticationAccessTokenKey]];
        [self setExpiryDate:nil];
        
        NSString *expiresValue = [information objectForKey:SKAuthenticationExpiresKey];
        if (expiresValue != nil) {
            NSDate *d = [NSDate dateWithTimeIntervalSinceNow:[expiresValue doubleValue]];
            [self setExpiryDate:d];
        }
        
        if ([self accessToken] == nil) {
            e = [NSError errorWithDomain:SKErrorDomain code:SKErrorCodeAccessTokenMissing userInfo:nil];
        }
    }
    
    _handler(e);

    
}

@end
