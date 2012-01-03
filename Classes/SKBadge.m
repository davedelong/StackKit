//
//  SKBadge.m
//  StackKit
//
//  Created by Dave DeLong on 1/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <StackKit/SKBadge.h>
#import <StackKit/SKObject_Internal.h>
#import <StackKit/SKConstants.h>

@implementation SKBadge

@dynamic name;

+ (NSString *)_uniquelyIdentifyingAPIKey {
    return SKAPIKeys.badge.badgeID;
}

+ (NSArray *)APIKeysBackingProperties {
    static dispatch_once_t onceToken;
    static NSArray *keys = nil;
    dispatch_once(&onceToken, ^{
        keys = [[NSArray alloc] initWithObjects:
                SKAPIKeys.badge.badgeID,
                SKAPIKeys.badge.name,
                SKAPIKeys.badge.rank,
                SKAPIKeys.badge.badgeType,
                nil];
    });
    return keys;
}

- (NSUInteger)badgeID {
    NSNumber *value = [self _valueForInfoKey:SKAPIKeys.badge.badgeID];
    return [value unsignedIntegerValue];
}

- (SKBadgeRank)rank {
    SKBadgeRank r = SKBadgeRankBronze;
    NSString *value = [self _valueForInfoKey:SKAPIKeys.badge.rank];
    if ([value isEqualToString:@"gold"]) {
        r = SKBadgeRankGold;
    } else if ([value isEqualToString:@"silver"]) {
        r = SKBadgeRankSilver;
    }
    return r;
}

- (BOOL)isTagBased {
    NSString *badgeType = [self _valueForInfoKey:SKAPIKeys.badge.badgeType];
    return [badgeType isEqualToString:@"tag_based"];
}

@end
