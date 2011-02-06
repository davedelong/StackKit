// 
//  SKBadge.m
//  StackKit
//
//  Created by Dave DeLong on 1/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SKBadge.h"
#import "SKConstants_Internal.h"
#import "SKObject+Private.h"
#import "SKDefinitions.h"

NSString * const SKBadgeID = @"badge_id";
NSString * const SKBadgeRank = @"rank";
NSString * const SKBadgeName = @"name";
NSString * const SKBadgeNumberAwarded = @"award_count";
NSString * const SKBadgeSummary = @"description";
NSString * const SKBadgeTagBased = @"tag_based";

NSString * const SKBadgesAwardedToUser = __SKUserID;

NSString * const SKBadgeRankGoldKey = @"gold";
NSString * const SKBadgeRankSilverKey = @"silver";
NSString * const SKBadgeRankBronzeKey = @"bronze";

@implementation SKBadge 

@dynamic badgeID;
@dynamic name;
@dynamic numberAwarded;
@dynamic rank;
@dynamic summary;
@dynamic tagBased;

@dynamic awards;

+ (NSString *) apiResponseDataKey {
    return @"badges";
}

+ (NSString *) apiResponseUniqueIDKey {
    return SKBadgeID;
}

+ (NSDictionary *)APIAttributeToPropertyMapping {
    static NSDictionary *mapping = nil;
    if (!mapping) {
        mapping = [[NSDictionary alloc] initWithObjectsAndKeys:
                   @"badgeID", SKBadgeID,
                   @"name", SKBadgeName,
                   @"numberAwarded", SKBadgeNumberAwarded,
                   @"rank", SKBadgeRank,
                   @"summary", SKBadgeSummary,
                   @"tagBased", SKBadgeTagBased,
                   nil];
    }
    return mapping;
}

- (id)willMergeValue:(id)value forProperty:(NSString *)property {
    if ([property isEqualToString:@"rank"]) {
		SKBadgeRank_t rank = SKBadgeRankBronze;
		if ([value isEqual:SKBadgeRankGoldKey]) {
			rank = SKBadgeRankGold;
		} else if ([value isEqual:SKBadgeRankSilverKey]) {
			rank = SKBadgeRankSilver;
		}
        return [NSNumber numberWithInt:rank];
    }
    return [super willMergeValue:value forProperty:property];
}

@end
