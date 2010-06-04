//
//  SKBadgeTest.m
//  StackKit
/**
 Copyright (c) 2010 Dave DeLong
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 **/

#import "SKBadgeTest.h"
#import "SKTestConstants.h"
#import <StackKit/StackKit.h>

@implementation SKBadgeTest

- (void) testBadgesByName {
	SKSite * site = [SKSite stackoverflowSite];
	
	SKFetchRequest * r = [[SKFetchRequest alloc] init];
	[r setEntity:[SKBadge class]];
	[r setPredicate:[NSPredicate predicateWithFormat:@"%K = %@", SKBadgeTagBased, [NSNumber numberWithBool:NO]]];

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
		badgeCount[rank] += [[badge numberAwarded] intValue];
	}
	
	STAssertTrue(badgeCount[SKBadgeRankBronze] == 33, @"bronze badge rank does not match (%d)", badgeCount[SKBadgeRankBronze]);
	STAssertTrue(badgeCount[SKBadgeRankSilver] == 19, @"silver badge rank does not match (%d)", badgeCount[SKBadgeRankSilver]);
	STAssertTrue(badgeCount[SKBadgeRankGold] == 2, @"gold badge rank does not match (%d)", badgeCount[SKBadgeRankGold]);
}

- (void) testUserBadges {
	SKSite * site = [SKSite stackoverflowSite];
	
	SKFetchRequest * r = [[SKFetchRequest alloc] init];
	[r setEntity:[SKBadge class]];
	[r setPredicate:[NSPredicate predicateWithFormat:@"%K = %@", SKBadgesAwardedToUser, [NSNumber numberWithInt:115730]]];
	NSArray * badges = [site executeSynchronousFetchRequest:r error:nil];
	[r release];
	
	int badgeCount[3] = {0, 0, 0};
	
	for (SKBadge * badge in badges) {
		SKBadgeRank_t rank = [badge rank];
		badgeCount[rank] += [[badge numberAwarded] intValue];
	}
	
	STAssertTrue(badgeCount[SKBadgeRankBronze] == 33, @"bronze badge rank does not match (%d)", badgeCount[SKBadgeRankBronze]);
	STAssertTrue(badgeCount[SKBadgeRankSilver] == 19, @"silver badge rank does not match (%d)", badgeCount[SKBadgeRankSilver]);
	STAssertTrue(badgeCount[SKBadgeRankGold] == 2, @"gold badge rank does not match (%d)", badgeCount[SKBadgeRankGold]);
}

@end
