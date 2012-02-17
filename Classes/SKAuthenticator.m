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

@interface SKAuthenticator ()

- (id)_init;

@property (assign,getter=isPresenting) BOOL presenting;
@property (copy) SKAuthenticationHandler handler;
@property (assign) SKAuthenticationOption options;
@property (assign) id context;

- (void)present;

@end

@implementation SKAuthenticator {
    SKAuthenticatorController *_controller;
}

+ (id)_sharedAuthenticator {
    static dispatch_once_t onceToken;
    static SKAuthenticator *authenticator = nil;
    dispatch_once(&onceToken, ^{
        authenticator = [[SKAuthenticator alloc] _init];
    });
    return authenticator;
}

+ (void)requestAuthenticationWithOptions:(SKAuthenticationOption)options presentingFrom:(id)window completionHandler:(SKAuthenticationHandler)handler {
    SKAuthenticator *auth = [SKAuthenticator _sharedAuthenticator];
    
    if ([auth isPresenting]) {
        NSError *error = [NSError errorWithDomain:SKErrorDomain code:SKErrorCodeAuthenticationInProgress userInfo:nil];
        handler(error);
    } else {
        [auth setHandler:handler];
        [auth setOptions:options];
        [auth setContext:window];
        
        [auth present];
    }
}

@synthesize presenting=_presenting;
@synthesize handler=_handler;
@synthesize options=_options;
@synthesize context=_context;

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
    
    [_controller presentInContext:_context handler:^(NSInteger code) {
        if (code == NSOKButton) {
            _handler(nil);
        } else {
            _handler([_controller error]);
        }
        
        _presenting = NO;
    }];
    
#elif StackKitMobile
    
#endif
    
}

@end
