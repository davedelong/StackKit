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
#import "SKMacros.h"

@implementation SKBadge 

+ (NSString *) apiResponseDataKey {
    return @"badges";
}

+ (NSString *) apiResponseUniqueIDKey {
    return SKAPIBadge_ID;
}

+ (NSDictionary *)APIAttributeToPropertyMapping {
    static NSDictionary *mapping = nil;
    if (!mapping) {
        mapping = [[NSDictionary alloc] initWithObjectsAndKeys:
                   @"badgeID", SKAPIBadge_ID,
                   @"name", SKAPIName,
                   @"numberAwarded", SKAPIAward_Count,
                   @"rank", SKAPIRank,
                   @"summary", SKAPIDescription,
                   @"tagBased", SKAPITag_Based,
                   @"awards", @"awards",
                   nil];
    }
    return mapping;
}

- (void) mergeInformationFromAPIResponseDictionary:(NSDictionary *)dictionary {
    if ([dictionary objectForKey:SKAPIUser] != nil && [dictionary objectForKey:SKAPIAward_Count] != nil) {
        NSMutableDictionary *mutable = [dictionary mutableCopy];
        NSDictionary *user = [NSDictionary dictionaryWithObjectsAndKeys:
                              [dictionary objectForKey:SKAPIAward_Count], SKAPIAward_Count,
                              [dictionary objectForKey:SKAPIUser], SKAPIUser,
                              nil];
        [mutable setObject:user forKey:@"awards"];
        [mutable removeObjectForKey:SKAPIAward_Count];
        dictionary = [mutable autorelease];
    }
    [super mergeInformationFromAPIResponseDictionary:dictionary];
}

- (id)transformValueToMerge:(id)value forProperty:(NSString *)property {
    if ([property isEqualToString:@"rank"]) {
		SKBadgeRank_t rank = SKBadgeRankBronze;
		if ([value isEqual:SKAPIGold]) {
			rank = SKBadgeRankGold;
		} else if ([value isEqual:SKAPISilver]) {
			rank = SKBadgeRankSilver;
		}
        return [NSNumber numberWithInt:rank];
    }
    return [super transformValueToMerge:value forProperty:property];
}

- (id)transformValueToMerge:(id)value forRelationship:(NSString *)relationship {
    // override for the sake of completeness
    if ([relationship isEqualToString:@"awards"]) {
        NSDictionary *user = [value objectForKey:SKAPIUser];
        NSNumber *awardCount = [value objectForKey:SKAPIAward_Count];
        
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

SK_GETTER(NSNumber *, badgeID);
SK_GETTER(NSString *, name);
SK_GETTER(NSNumber *, numberAwarded);
SK_GETTER(NSNumber *, rank);
SK_GETTER(NSString *, summary);
SK_GETTER(NSNumber *, tagBased);
SK_GETTER(NSSet*, awards);

@end
