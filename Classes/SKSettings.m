//
//  SKSettings.m
//  StackKit
//
//  Created by Dave DeLong on 2/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SKSettings.h"
#import <StackKit/SKFunctions.h>
#import <StackKit/SKMacros.h>
#import <StackKit/SKAuthenticator.h>

@implementation SKSettings {
    dispatch_queue_t settingsQueue;
}

@synthesize isAuthenticated=_isAuthenticated;
@synthesize authenticationScope=_authenticationScope;
@synthesize authenticationExpirationDate=_authenticationExpirationDate;
@synthesize accessToken=_accessToken;
@synthesize clientID=_clientID;


+ (id)sharedSettings {
    static SKSettings *settings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        settings = [NSAllocateObject([SKSettings class], 0, nil) _init];
    });
    return settings;
}

+ (id)allocWithZone:(NSZone *)zone {
    [NSException raise:NSInvalidArgumentException format:@"You may not allocate an SKSettings object"];
    return nil;
}

- (id)_init {
    self = [super init];
    if (self) {
        settingsQueue = dispatch_queue_create("com.davedelong.stackkit.settings", 0);
        dispatch_async(settingsQueue, ^{
            NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[self _cacheFile]];
            if (settings) {
                _isAuthenticated = [[settings objectForKey:PROPERTY(isAuthenticated)] boolValue];
                _authenticationScope = [[settings objectForKey:PROPERTY(authenticationScope)] integerValue];
                _authenticationExpirationDate = [[settings objectForKey:PROPERTY(authenticationExpirationDate)] retain];
                _accessToken = [[settings objectForKey:PROPERTY(accessToken)] retain];
                _clientID = [[settings objectForKey:PROPERTY(clientID)] retain];
                
                [self _validateSettings];
            }
        });
    }
    return self;
}

- (NSString *)_cacheFile {
    return [SKApplicationSupportDirectory() stringByAppendingPathComponent:@"settings.plist"];
}

- (void)_validateSettings {
    NSAssert(dispatch_get_current_queue() == settingsQueue, @"%@ invoked on invalid queue", NSStringFromSelector(_cmd));
    BOOL settingsAreValid = YES;
    
    if (_accessToken != nil) {
        _isAuthenticated = YES;
        
        if (_authenticationExpirationDate && [_authenticationExpirationDate timeIntervalSinceReferenceDate] < [NSDate timeIntervalSinceReferenceDate]) {
            settingsAreValid = NO;
        }
    } else {
        settingsAreValid = NO;
    }
    
    if (settingsAreValid == NO) {
        [_accessToken release], _accessToken = nil;
        [_authenticationExpirationDate release], _authenticationExpirationDate = nil;
        _authenticationScope = 0;
        _isAuthenticated = NO;
    }
}

- (void)_saveSettings {
    NSAssert(dispatch_get_current_queue() == settingsQueue, @"%@ invoked on invalid queue", NSStringFromSelector(_cmd));
    [self _validateSettings];
    
    NSMutableDictionary *d = [NSMutableDictionary dictionary];
    if (_clientID) {
        [d setObject:_clientID forKey:PROPERTY(clientID)];
    }
    
    if (_isAuthenticated) {
        [d setObject:[NSNumber numberWithBool:YES] forKey:PROPERTY(isAuthenticated)];
        [d setObject:_accessToken forKey:PROPERTY(accessToken)];
        [d setObject:[NSNumber numberWithInteger:_authenticationScope] forKey:PROPERTY(authenticationScope)];
        if (_authenticationExpirationDate) {
            [d setObject:_authenticationExpirationDate forKey:PROPERTY(authenticationExpirationDate)];
        }
    }
    
    [d writeToFile:[self _cacheFile] atomically:YES];
}

#pragma mark -
#pragma mark Properties

- (BOOL)isAuthenticated {
    __block BOOL returnValue = NO;
    dispatch_sync(settingsQueue, ^{
        [self _validateSettings];
        returnValue = _isAuthenticated;
    });
    return returnValue;
}

- (SKAuthenticationScope)authenticationScope {
    __block SKAuthenticationScope scope = 0;
    dispatch_sync(settingsQueue, ^{
        [self _validateSettings];
        scope = _authenticationScope;
    });
    return scope;
}

- (NSDate *)authenticationExpirationDate {
    __block NSDate *date = nil;
    dispatch_sync(settingsQueue, ^{
        [self _validateSettings];
        date = _authenticationExpirationDate;
    });
    return date;
}

- (NSString *)accessToken {
    __block NSString *token = nil;
    dispatch_sync(settingsQueue, ^{
        [self _validateSettings];
        token = _accessToken;
    });
    return token;
}

- (NSString *)clientID {
    __block NSString *clientID = nil;
    dispatch_sync(settingsQueue, ^{
        [self _validateSettings];
        clientID = _clientID;
    });
    return clientID;
}

- (void)setClientID:(NSString *)clientID {
    dispatch_sync(settingsQueue, ^{
        [_clientID release];
        _clientID = [clientID copy];
        [self _saveSettings];
    });
}

#pragma mark -

- (void)requestAuthenticationScope:(SKAuthenticationScope)scope presentingFromContext:(id)context completionHandler:(SKErrorHandler)handler {
    if ([self isAuthenticated]) {
        NSError *e = [NSError errorWithDomain:SKErrorDomain code:SKErrorCodeAuthenticatedAlready userInfo:nil];
        handler(e);
        return;
    }
    
    handler = [handler copy];
    SKAuthenticator *auth = [SKAuthenticator sharedAuthenticator];
    [auth requestAuthenticationWithOptions:scope presentingFrom:context completionHandler:^(NSError *error) {
        if (error == nil) {
            NSString *token = [auth accessToken];
            SKAuthenticationScope acquiredScope = [auth scope];
            NSDate *expiryDate = [auth expiryDate];
            
            dispatch_sync(settingsQueue, ^{
                [_accessToken release];
                [_authenticationExpirationDate release];
                
                _accessToken = [token retain];
                _authenticationExpirationDate = [expiryDate retain];
                _authenticationScope = acquiredScope;
                _isAuthenticated = YES;
                
                [self _saveSettings];
            });
        }
        
        handler(error);
    }];
    [handler release];
}

- (void)requestUsersForAuthenticatedUser:(SKRequestHandler)handler {

}

@end
