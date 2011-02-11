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
#import "SKUser.h"
#import "SKBadgeAward.h"

NSString * const SKBadgeID = @"badge_id";
NSString * const SKBadgeRank = @"rank";
NSString * const SKBadgeName = @"name";
NSString * const SKBadgeNumberAwarded = @"award_count";
NSString * const SKBadgeSummary = @"description";
NSString * const SKBadgeTagBased = @"tag_based";

NSString * const SKBadgesAwardedToUser = __SKUserID;

NSString * const SKBadgeAwards = @"awards";
NSString * const SKBadgeUser = @"user";
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

+ (NSString *) entityName {
    return @"SKBadge";
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
                   @"awards", SKBadgeAwards,
                   nil];
    }
    return mapping;
}

- (void) mergeInformationFromAPIResponseDictionary:(NSDictionary *)dictionary {
    if ([dictionary objectForKey:SKBadgeUser] != nil && [dictionary objectForKey:SKBadgeNumberAwarded] != nil) {
        NSMutableDictionary *mutable = [dictionary mutableCopy];
        NSDictionary *user = [NSDictionary dictionaryWithObjectsAndKeys:
                              [dictionary objectForKey:SKBadgeNumberAwarded], SKBadgeNumberAwarded,
                              [dictionary objectForKey:SKBadgeUser], SKBadgeUser,
                              nil];
        [mutable setObject:user forKey:SKBadgeAwards];
        [mutable removeObjectForKey:SKBadgeNumberAwarded];
        dictionary = [mutable autorelease];
    }
    [super mergeInformationFromAPIResponseDictionary:dictionary];
}

- (id)transformValueToMerge:(id)value forProperty:(NSString *)property {
    if ([property isEqualToString:@"rank"]) {
		SKBadgeRank_t rank = SKBadgeRankBronze;
		if ([value isEqual:SKBadgeRankGoldKey]) {
			rank = SKBadgeRankGold;
		} else if ([value isEqual:SKBadgeRankSilverKey]) {
			rank = SKBadgeRankSilver;
		}
        return [NSNumber numberWithInt:rank];
    }
    return [super transformValueToMerge:value forProperty:property];
}

- (id)transformValueToMerge:(id)value forRelationship:(NSString *)relationship {
    // override for the sake of completeness
    if ([relationship isEqualToString:SKBadgeAwards]) {
        NSDictionary *user = [value objectForKey:SKBadgeUser];
        NSNumber *awardCount = [value objectForKey:SKBadgeNumberAwarded];
        
        SKUser *userObject = [SKUser objectMergedWithDictionary:user inSite:[self site]];
        SKBadgeAward *award = nil;
        for (SKBadgeAward *awardedBadge in [userObject awardedBadges]) {
            if ([[awardedBadge badge] isEqual:self]) {
                award = awardedBadge;
                break;
            }
        }
        if (award == nil) {
            award = [SKBadgeAward insertInManagedObjectContext:[self managedObjectContext]];
            [award setValue:userObject forKey:@"user"];
        }
        
        [award setValue:awardCount forKey:@"numberOfTimesAwarded"];
        
        return award;
    }
    return [super transformValueToMerge:value forRelationship:relationship];
}

@end
