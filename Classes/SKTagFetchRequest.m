//
//  SKTagFetchRequest.m
//  StackKit
//
//  Created by Dave DeLong on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SKTagFetchRequest.h"
#import <StackKit/SKFunctions.h>
#import <StackKit/SKConstants.h>
#import <StackKit/SKTag.h>
#import <StackKit/SKUser.h>

@implementation SKTagFetchRequest

@synthesize minDate=_minDate;
@synthesize maxDate=_maxDate;
@synthesize nameContains=_nameContains;
@synthesize userIDs=_userIDs;

+ (Class)_targetClass { return [SKTag class]; }

- (id)init {
    self = [super init];
    if (self) {
        _userIDs = [[NSMutableIndexSet alloc] init];
    }
    return self;
}

- (void)dealloc {
    [_minDate release];
    [_maxDate release];
    [_nameContains release];
    [_userIDs release];
    [super dealloc];
}

- (id)whoseNameContains:(NSString *)name {
    [self setNameContains:name];
    return self;
}

- (id)sortedByPopularity {
    [self setSortKey:@"count"];
    return self;
}

- (id)sortedByLastUsedDate {
    [self setSortKey:@"activity"];
    return self;
}

- (id)sortedByName {
    [self setSortKey:SKAPIKeys.tag.name];
    return self;
}

- (id)usedOnQuestionsCreatedAfter:(NSDate *)date {
    [self setMinDate:date];
    return self;
}

- (id)usedOnQuestionsCreatedBefore:(NSDate *)date {
    [self setMaxDate:date];
    return self;
}

- (id)usedByUsers:(SKUser *)user, ... {
    if (user != nil) {
        [_userIDs addIndex:[user userID]];
        va_list list;
        va_start(list, user);
        
        while((user = va_arg(list, SKUser*)) != nil) {
            [_userIDs addIndex:[user userID]];
        }
        
        va_end(list);
    }
    return self;
}

- (id)usedByUsersWithIDs:(NSUInteger)userID, ... {
    if (userID > 0) {
        [_userIDs addIndex:userID];
        va_list list;
        va_start(list, userID);
        
        NSUInteger nextID = 0;
        while ((nextID = va_arg(list, NSUInteger)) != 0) {
            [_userIDs addIndex:nextID];
        }
        
        va_end(list);
    }
    return self;
}

- (NSString *)_path {
    NSString *p = @"tags";
    if ([_userIDs count] > 0) {
        p = [NSString stringWithFormat:@"users/%@/tags", SKQueryString(_userIDs)];        
    }
    return p;
}

- (NSMutableDictionary *)_queryDictionary {
    NSMutableDictionary *d = [super _queryDictionary];
    
    if (_minDate) {
        [d setObject:SKQueryString(_minDate) forKey:SKQueryKeys.fromDate];
    }
    
    if (_maxDate) {
        [d setObject:SKQueryString(_maxDate) forKey:SKQueryKeys.toDate];
    }
    
    if ([_userIDs count] == 0 && [_nameContains length] > 0) {
        [d setObject:SKQueryString(_nameContains) forKey:SKQueryKeys.tag.nameContains];
    }
    
    return d;
}

@end
