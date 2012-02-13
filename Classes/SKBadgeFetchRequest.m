//
//  SKBadgeFetchRequest.m
//  StackKit
//
//  Created by Dave DeLong on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SKBadgeFetchRequest.h"
#import <StackKit/SKFunctions.h>
#import <StackKit/SKConstants.h>
#import <StackKit/SKBadge.h>
#import <StackKit/SKUser.h>
#import <StackKit/SKMacros.h>

@implementation SKBadgeFetchRequest

@synthesize userIDs=_userIDs;
@synthesize badgeIDs=_badgeIDs;
@synthesize requestedType=_requestedType;
@synthesize nameContains=_nameContains;

+ (Class)_targetClass { return [SKBadge class]; }

- (id)init {
    self = [super init];
    if (self) {
        _userIDs = [[NSMutableIndexSet alloc] init];
        _badgeIDs = [[NSMutableIndexSet alloc] init];
    }
    return self;
}

- (void)dealloc {
    [_userIDs release];
    [_badgeIDs release];
    [_nameContains release];
    [super dealloc];
}

- (id)sortedByRank {
    [self setSortKey:SKSortValues.badge.rank];
    return self;
}

- (id)sortedByName {
    [self setSortKey:SKSortValues.badge.name];
    return self;
}
- (id)sortedByTagBased {
    [self setSortKey:SKSortValues.badge.type];
    return self;
}

- (id)tagBasedOnly {
    _requestedType = _SKBadgeTypeTag;
    return self;
}

- (id)namedOnly {
    _requestedType = _SKBadgeTypeNamed;
    return self;
}

- (id)whoseNameContains:(NSString *)name {
    [self setNameContains:name];
    return self;
}

- (id)withIDs:(NSUInteger)badgeID, ... {
    INTEGER_LIST(_badgeIDs, badgeID);
    return self;
}

- (id)awardedToUsers:(SKUser *)user, ...  {
    OBJECT_LIST(_userIDs, user, userID);
    return self;
}

- (id)awardedToUsersWithIDs:(NSUInteger)userID, ...  {
    INTEGER_LIST(_userIDs, userID);
    return self;
}

- (NSString *)_path {
    if (_requestedType == _SKBadgeTypeTag) {
        return @"badges/tags";
    } else if (_requestedType == _SKBadgeTypeNamed) {
        return @"badges/named";
    }
    
    if ([_badgeIDs count] > 0) {
        return [NSString stringWithFormat:@"badges/%@", SKQueryString(_badgeIDs)];
    }
    
    if ([_userIDs count] > 0) {
        return [NSString stringWithFormat:@"users/%@/badges", SKQueryString(_userIDs)];
    }
    
    return @"badges";
}

- (NSMutableDictionary *)_queryDictionary {
    if (_requestedType != _SKBadgeTypeAll && [[self sortKey] isEqualToString:@"type"]) {
        // you can only sort by type if you're requesting all kinds of badges
        [self setSortKey:SKAPIKeys.badge.rank];
    }
    
    NSMutableDictionary *d = [super _queryDictionary];
    
    if ([_nameContains length]) {
        NSString *path = [self _path];
        
        if ([path isEqualToString:@"badges/tags"] ||
            [path isEqualToString:@"badges/named"] ||
            [path isEqualToString:@"badges"]) {
            
            [d setObject:_nameContains forKey:SKQueryKeys.badge.nameContains];
        }
    }
    
    return d;
}

@end
