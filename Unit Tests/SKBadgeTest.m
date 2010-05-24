//
//  SKBadgeTest.m
//  StackKit
//
//  Created by Dave DeLong on 4/4/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "SKBadgeTest.h"
#import "SKTestConstants.h"
#import <StackKit/StackKit.h>

@implementation SKBadgeTest

- (void) testBadgesByName {
	SKSite * site = [SKSite stackoverflowSite];
	
	SKFetchRequest * r = [[SKFetchRequest alloc] init];
	[r setEntity:[SKBadge class]];

	NSError * error = nil;
	NSArray * badges = [site executeSynchronousFetchRequest:r error:&error];
	[r release];
	
	STAssertNil(error, @"error should be nil");
	
	NSArray * actualNames = [badges valueForKey:SKBadgeName];
	
	NSArray * expectedNames = [NSArray arrayWithObjects:@"Autobiographer",
							   @"Beta",
							   @"Citizen Patrol",
							   @"Civic Duty",
							   @"Cleanup",
							   @"Commentator",
							   @"Critic",
							   @"Disciplined",
							   @"Editor",
							   @"Electorate",
							   @"Enlightened",
							   @"Enthusiast",
							   @"Epic",
							   @"Famous Question",
							   @"Fanatic",
							   @"Favorite Question",
							   @"Generalist",
							   @"Good Answer",
							   @"Good Question",
							   @"Great Answer",
							   @"Great Question",
							   @"Guru",
							   @"Legendary",
							   @"Mortarboard",
							   @"Necromancer",
							   @"Nice Answer",
							   @"Nice Question",
							   @"Notable Question",
							   @"Organizer",
							   @"Peer Pressure",
							   @"Popular Question",
							   @"Populist",
							   @"Pundit",
							   @"Reversal",
							   @"Scholar",
							   @"Self-Learner",
							   @"Stellar Question",
							   @"Strunk & White",
							   @"Student",
							   @"Supporter",
							   @"Taxonomist",
							   @"Teacher",
							   @"Tumbleweed",
							   @"Yearling",
							   nil];
	
	STAssertEqualObjects(actualNames, expectedNames, @"expected names should match");
	
	STAssertTrue([badges count] == 44, @"there should be 44 badges");
}

- (void) testBadgesByTag {
	SKSite * site = [SKSite stackoverflowSite];
	
	SKFetchRequest * r = [[SKFetchRequest alloc] init];
	[r setEntity:[SKBadge class]];
	[r setPredicate:[NSPredicate predicateWithFormat:@"%K = %@", SKBadgeTagBased, [NSNumber numberWithBool:YES]]];
	
	NSError * error = nil;
	NSArray * badges = [site executeSynchronousFetchRequest:r error:&error];
	[r release];
	
	STAssertNil(error, @"error should be nil");
	
	for (SKBadge * badge in badges) {
		STAssertTrue([badge isTagBased] == YES, @"badge %@ should be tag-based", [badge name]);
	}
}

- (void) testBadgesForUser {
	SKSite * site = [SKSite stackoverflowSite];
	
	SKFetchRequest * r = [[SKFetchRequest alloc] init];
	[r setEntity:[SKBadge class]];
	[r setPredicate:[NSPredicate predicateWithFormat:@"%K = %@", SKUserID, [NSNumber numberWithInt:115730]]];
	
	NSArray * badges = [site executeSynchronousFetchRequest:r error:nil];
	[r release];
	
	int badgeCount[3] = {0, 0, 0};
	
	for (SKBadge * badge in badges) {
		SKBadgeRank_t rank = [badge rank];
		badgeCount[rank] += [badge numberAwarded];
	}
	
	STAssertTrue(badgeCount[SKBadgeRankBronze] == 33, @"bronze badge rank does not match (%d)", badgeCount[SKBadgeRankBronze]);
	STAssertTrue(badgeCount[SKBadgeRankSilver] == 18, @"silver badge rank does not match (%d)", badgeCount[SKBadgeRankSilver]);
	STAssertTrue(badgeCount[SKBadgeRankGold] == 2, @"gold badge rank does not match (%d)", badgeCount[SKBadgeRankGold]);
}

- (void) testUserBadges {
	SKSite * site = [SKSite stackoverflowSite];
	
	SKFetchRequest * r = [[SKFetchRequest alloc] init];
	[r setEntity:[SKUser class]];
	[r setPredicate:[NSPredicate predicateWithFormat:@"%K = %@", SKUserID, [NSNumber numberWithInt:115730]]];
	NSArray * matches = [site executeSynchronousFetchRequest:r error:nil];
	[r release];
	
	STAssertTrue([matches count] == 1, @"wrong number of users");
	
	SKUser * davedelong = [matches objectAtIndex:0];
	
	NSArray * badges = [davedelong badges];
	
	STAssertTrue ([matches count] > 0, @"not enough badges");
	int badgeCount[3] = {0, 0, 0};
	
	for (SKBadge * badge in badges) {
		SKBadgeRank_t rank = [badge rank];
		badgeCount[rank] += [badge numberAwarded];
	}
	
	STAssertTrue(badgeCount[SKBadgeRankBronze] == 33, @"bronze badge rank does not match (%d)", badgeCount[SKBadgeRankBronze]);
	STAssertTrue(badgeCount[SKBadgeRankSilver] == 18, @"silver badge rank does not match (%d)", badgeCount[SKBadgeRankSilver]);
	STAssertTrue(badgeCount[SKBadgeRankGold] == 2, @"gold badge rank does not match (%d)", badgeCount[SKBadgeRankGold]);
}

@end
