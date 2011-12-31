//
//  SKFetchRequest.m
//  StackKit
//
//  Created by Dave DeLong on 12/31/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <StackKit/SKFetchRequest_Internal.h>
#import <StackKit/SKConstants.h>
#import <StackKit/SKFunctions.h>

@implementation SKFetchRequest

+ (SKUserFetchRequest *)requestForFetchingUsers {
    if (self != [SKFetchRequest class]) {
        [NSException raise:NSInternalInconsistencyException 
                    format:@"+%@ may only be invoked on SKFetchRequest", NSStringFromSelector(_cmd)];
    }
    
    return [[[SKUserFetchRequest alloc] init] autorelease];
}

@end

@implementation SKUserFetchRequest

@synthesize minDate=_minDate;
@synthesize maxDate=_maxDate;
@synthesize sortKey=_sortKey;
@synthesize nameContains=_nameContains;

- (void)dealloc {
    [_minDate release];
    [_maxDate release];
    [_sortKey release];
    [_nameContains release];
    [super dealloc];
}

- (id)createdSince:(NSDate *)date {
    [self setMinDate:date];
    return self;
}

- (id)createdBefore:(NSDate *)date {
    [self setMaxDate:date];
    return self;
}

- (id)sortedByCreationDate {
    [self setSortKey:SKResponseKeys.user.creationDate];
    return self;
}

- (id)sortedByName {
    [self setSortKey:SKResponseKeys.user.displayName];
    return self;
}

- (id)sortedByReputation {
    [self setSortKey:SKResponseKeys.user.reputation];
    return self;
}

- (id)sortedByLastModifiedDate {
    [self setSortKey:SKResponseKeys.user.lastModifiedDate];
    return self;
}

- (id)whoseDisplayNameContains:(NSString *)name {
    [self setNameContains:name];
    return self;
}

@end
