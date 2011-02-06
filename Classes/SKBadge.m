// 
//  SKBadge.m
//  StackKit
//
//  Created by Dave DeLong on 1/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SKBadge.h"
#import "SKConstants_Internal.h"

NSString * const SKBadgeID = @"badge_id";
NSString * const SKBadgeRank = @"rank";
NSString * const SKBadgeName = @"name";
NSString * const SKBadgeNumberAwarded = @"award_count";
NSString * const SKBadgeSummary = @"description";
NSString * const SKBadgeTagBased = @"tag_based";

NSString * const SKBadgesAwardedToUser = __SKUserID;

@implementation SKBadge 

@dynamic badgeID;
@dynamic name;
@dynamic numberAwarded;
@dynamic rank;
@dynamic summary;
@dynamic tagBased;

@dynamic awards;

@end
