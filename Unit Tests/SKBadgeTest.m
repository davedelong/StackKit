//
//  SKBadgeTest.m
//  StackKit
/**
  Copyright (c) 2011 Dave DeLong
 
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
	SKSite * site = [[SKSiteManager sharedManager] stackOverflowSite];
	
	SKFetchRequest * r = [[SKFetchRequest alloc] init];
	[r setEntity:[SKBadge class]];
	[r setPredicate:[NSPredicate predicateWithFormat:@"tagBased = %@", [NSNumber numberWithBool:NO]]];

	NSError * error = nil;
	NSArray * badges = [site executeSynchronousFetchRequest:r error:&error];
	[r release];
	
	STAssertNil(error, @"error should be nil");
	
	for (SKBadge * badge in badges) {
		STAssertFalse([[badge tagBased] boolValue], @"Unexpected tag-based badge: %@", badge);
	}
}

- (void) testBadgesByTag {
	SKSite * site = [[SKSiteManager sharedManager] stackOverflowSite];
	
	SKFetchRequest * r = [[SKFetchRequest alloc] init];
	[r setEntity:[SKBadge class]];
	[r setPredicate:[NSPredicate predicateWithFormat:@"tagBased = %@", [NSNumber numberWithBool:YES]]];
	
	NSError * error = nil;
	NSArray * badges = [site executeSynchronousFetchRequest:r error:&error];
	[r release];
	
	STAssertNil(error, @"error should be nil");
	
	for (SKBadge * badge in badges) {
		STAssertTrue([[badge tagBased] boolValue], @"badge %@ should be tag-based", [badge name]);
	}
}

- (void) testBadgesForUser {
	SKSite * site = [[SKSiteManager sharedManager] stackOverflowSite];
	
	SKFetchRequest * r = [[SKFetchRequest alloc] init];
	[r setEntity:[SKBadge class]];
	[r setPredicate:[NSPredicate predicateWithFormat:@"userID = %@", [NSNumber numberWithInt:115730]]];
	
	NSArray * badges = [site executeSynchronousFetchRequest:r error:nil];
	[r release];
	
	int badgeCount[3] = {0, 0, 0};
	
	for (SKBadge * badge in badges) {
		SKBadgeRank_t rank = [[badge rank] intValue];
		badgeCount[rank] += [[badge numberAwarded] intValue];
	}
	
	STAssertTrue(badgeCount[SKBadgeRankBronze] >= 35, @"bronze badge rank does not match (%d)", badgeCount[SKBadgeRankBronze]);
	STAssertTrue(badgeCount[SKBadgeRankSilver] >= 21, @"silver badge rank does not match (%d)", badgeCount[SKBadgeRankSilver]);
	STAssertTrue(badgeCount[SKBadgeRankGold] >= 2, @"gold badge rank does not match (%d)", badgeCount[SKBadgeRankGold]);
}

- (void) testUserBadges {
	SKSite * site = [[SKSiteManager sharedManager] stackOverflowSite];
	
	SKFetchRequest * r = [[SKFetchRequest alloc] init];
	[r setEntity:[SKBadge class]];
	[r setPredicate:[NSPredicate predicateWithFormat:@"awards.user CONTAINS %@", [NSNumber numberWithInt:115730]]];
	NSArray * badges = [site executeSynchronousFetchRequest:r error:nil];
	[r release];
	
	int badgeCount[3] = {0, 0, 0};
	
	for (SKBadge * badge in badges) {
		SKBadgeRank_t rank = [[badge rank] intValue];
		badgeCount[rank] += [[badge numberAwarded] intValue];
	}
	
	STAssertTrue(badgeCount[SKBadgeRankBronze] >= 35, @"bronze badge rank does not match (%d)", badgeCount[SKBadgeRankBronze]);
	STAssertTrue(badgeCount[SKBadgeRankSilver] >= 21, @"silver badge rank does not match (%d)", badgeCount[SKBadgeRankSilver]);
	STAssertTrue(badgeCount[SKBadgeRankGold] >= 2, @"gold badge rank does not match (%d)", badgeCount[SKBadgeRankGold]);
}

@end
