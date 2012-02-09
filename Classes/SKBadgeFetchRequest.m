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
    [self setSortKey:SKAPIKeys.badge.rank];
    return self;
}

- (id)sortedByName {
    [self setSortKey:SKAPIKeys.badge.name];
    return self;
}
- (id)sortedByTagBased {
    [self setSortKey:@"type"];
    return self;
}

- (id)tagBasedOnly {
    [self setRequestedType:_SKBadgeTypeTag];
    return self;
}

- (id)namedOnly {
    [self setRequestedType:_SKBadgeTypeNamed];
    return self;
}

- (id)whoseNameContains:(NSString *)name {
    [self setNameContains:name];
    return self;
}

- (id)withIDs:(NSUInteger)badgeID, ... {
    if (badgeID > 0) {
        [_badgeIDs addIndex:badgeID];
        va_list list;
        va_start(list, badgeID);
        
        NSUInteger nextID = 0;
        while ((nextID = va_arg(list, NSUInteger)) != 0) {
            [_badgeIDs addIndex:nextID];
        }
        
        va_end(list);
    }
    return self;
}

- (id)usedByUsers:(SKUser *)user, ...  {
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

- (id)usedByUsersWithIDs:(NSUInteger)userID, ...  {
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
