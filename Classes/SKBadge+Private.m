//
//  SKBadge+Private.m
//  StackKit
//
//  Created by Dave DeLong on 1/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SKBadge+Private.h"
#import "SKBadge+Public.h"
#import "SKUser+Public.h"
#import "SKDefinitions.h"

NSString * const SKBadgeRankGoldKey = @"gold";
NSString * const SKBadgeRankSilverKey = @"silver";
NSString * const SKBadgeRankBronzeKey = @"bronze";

@implementation SKBadge (Private)

@dynamic badgeID;
@dynamic summary;
@dynamic name;
@dynamic rank;
@dynamic numberAwarded;
@dynamic tagBased;
@dynamic users;

- (void) mergeInformationFromDictionary:(NSDictionary *)dictionary {

	[self setBadgeID:[dictionary objectForKey:SKBadgeID]];
	[self setSummary:[dictionary objectForKey:SKBadgeDescription]];
	[self setName:[dictionary objectForKey:SKBadgeName]];
	[self setNumberAwarded:[dictionary objectForKey:SKBadgeAwardCount]];
	
	if ([[dictionary objectForKey:SKBadgeRank] isEqual:SKBadgeRankGoldKey]) {
		[self setRank:[NSNumber numberWithInt:SKBadgeRankGold]];
	} else if ([[dictionary objectForKey:SKBadgeRank] isEqual:SKBadgeRankSilverKey]) {
		[self setRank:[NSNumber numberWithInt:SKBadgeRankSilver]];
	} else {
		[self setRank:[NSNumber numberWithInt:SKBadgeRankBronze]];
	}
	
	[self setTagBased:[dictionary objectForKey:SKBadgeTagBased]];
}

+ (NSString *) dataKey {
	return @"badges";
}

+ (NSDictionary *) APIAttributeToPropertyMapping {
	static NSDictionary * _kSKBadgeMappings = nil;
	if (_kSKBadgeMappings == nil) {
		_kSKBadgeMappings = [[NSDictionary alloc] initWithObjectsAndKeys:
							 @"name", SKBadgeName,
							 @"description", SKBadgeDescription,
							 @"ID", SKBadgeID,
							 @"rank", SKBadgeRank,
							 @"numberAwarded", SKBadgeAwardCount,
							 @"tagBased", SKBadgeTagBased,
							 @"userID", SKUserID,
							 nil];
	}
	return _kSKBadgeMappings;
}

@end
