//
//  SKResponse.m
//  StackKit
//
//  Created by Dave DeLong on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SKResponse.h"
#import <StackKit/SKTypes.h>
#import <StackKit/SKConstants.h>

@implementation SKResponse {
    NSDictionary *_json;
    NSDate *_backoffDate;
    NSError *_error;
}

+ (id)responseFromJSON:(NSDictionary *)json error:(NSError *)error {
    NSParameterAssert(json != nil);
    SKResponse *r = [[SKResponse alloc] _initWithJSON:json error:error];
    return [r autorelease];
}

- (id)_initWithJSON:(NSDictionary *)json error:(NSError *)error {
    self = [super init];
    if (self) {
        _json = [json retain];
        NSNumber *backoffInterval = [_json objectForKey:SKAPIKeys.backOff];
        if (backoffInterval != nil) {
            _backoffDate = [[NSDate alloc] initWithTimeIntervalSinceNow:[backoffInterval doubleValue]];
        }
        _error = [error retain];
    }
    return self;
}

- (void)dealloc {
    [_json release];
    [_backoffDate release];
    [_error release];
    [super dealloc];
}

- (NSArray *)items {
    return [_json objectForKey:SKAPIKeys.items];
}

- (BOOL)hasMore {
    return [[_json objectForKey:SKAPIKeys.hasMore] boolValue];
}

- (NSDate *)backoffDate {
    return _backoffDate;
}

- (NSError *)error {
    if ([self errorID] == 0) { return nil; }
    
    NSInteger code = [self errorID];
    NSString *description = @"An unknown error occurred. Check the NSUnderlyingErrorKey for more information.";
    
    if ([self errorMessage] != nil) {
        description = [self errorMessage];
    }
    
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:description forKey:NSLocalizedDescriptionKey];
    if (_error) {
        [info setObject:_error forKey:NSUnderlyingErrorKey];
    }
    
    NSError *error = [NSError errorWithDomain:SKErrorDomain code:code userInfo:info];
    
    return error;
}

- (NSInteger)errorID {
    return [[_json objectForKey:SKAPIKeys.errorID] integerValue];
}

- (NSString *)errorName {
    return [_json objectForKey:SKAPIKeys.errorName];
}

- (NSString *)errorMessage {
    return [_json objectForKey:SKAPIKeys.errorMessage];
}

- (NSInteger)page {
    return [[_json objectForKey:SKAPIKeys.page] integerValue];
}

- (NSInteger)pageSize {
    return [[_json objectForKey:SKAPIKeys.pageSize] integerValue];
}

- (NSInteger)quotaMax {
    return [[_json objectForKey:SKAPIKeys.quotaMax] integerValue];
}

- (NSInteger)quotaRemaining {
    return [[_json objectForKey:SKAPIKeys.quotaRemaining] integerValue];
}

- (NSInteger)total {
    return [[_json objectForKey:SKAPIKeys.total] integerValue];
}

- (NSString *)type {
    return [_json objectForKey:SKAPIKeys.type];
}

@end
