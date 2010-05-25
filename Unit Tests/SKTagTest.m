//
//  SKTagTest.m
//  StackKit
//
//  Created by Dave DeLong on 4/5/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "SKTagTest.h"
#import <StackKit/StackKit.h>

@implementation SKTagTest

- (void) testRecent {
	SKSite * site = [SKSite stackoverflowSite];
	
	SKFetchRequest * r = [[SKFetchRequest alloc] init];
	[r setEntity:[SKTag class]];

	NSError * error = nil;
	NSArray * recent = [site executeSynchronousFetchRequest:r error:&error];
	[r release];
	
	STAssertNil(error, @"error should be nil: %@", error);
	
	/**
	 There's really no way we can verify that these are accurate results without more information returned by the SO API
	 **/
	STAssertTrue([recent count] > 0, @"there should be > 0 recent tags");
}

- (void) testPopular {
	SKSite * site = [SKSite stackoverflowSite];
	
	SKFetchRequest * r = [[SKFetchRequest alloc] init];
	[r setEntity:[SKTag class]];
	[r setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:SKTagCount ascending:NO]]];
	
	NSError * error = nil;
	NSArray * popular = [site executeSynchronousFetchRequest:r error:&error];
	[r release];
	
	STAssertNil(error, @"error should be nil: %@", error);
	
	NSUInteger previousCount = UINT_MAX;
	for (SKTag * tag in popular) {
		STAssertTrue(previousCount >= [tag numberOfTaggedQuestions], @"out-of-order tag! (%lu >=? %lu)", previousCount, [tag numberOfTaggedQuestions]);
		previousCount = [tag numberOfTaggedQuestions];
	}
}

- (void) testName {
	SKSite * site = [SKSite stackoverflowSite];
	
	SKFetchRequest * r = [[SKFetchRequest alloc] init];
	[r setEntity:[SKTag class]];
	[r setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:SKTagName ascending:YES]]];
	
	NSError * error = nil;
	NSArray * popular = [site executeSynchronousFetchRequest:r error:&error];
	[r release];
	
	STAssertTrue(error == nil, @"error should be nil: %@", error);
	
	NSString * previousName = nil;
	for (SKTag * tag in popular) {
		if (previousName != nil) {
			STAssertTrue([[tag name] compare:previousName] == NSOrderedDescending, @"out-of-order tag! (%@ >=? %@)", previousName, [tag name]);
		}
		previousName = [tag name];
	}
}

- (void) testUser {
	SKSite * site = [SKSite stackoverflowSite];
	
	SKFetchRequest * r = [[SKFetchRequest alloc] init];
	[r setEntity:[SKTag class]];
	[r setPredicate:[NSPredicate predicateWithFormat:@"%K = %@", SKUserID, [NSNumber numberWithInt:115730]]];
	
	NSError * error = nil;
	NSArray * userTags = [site executeSynchronousFetchRequest:r error:&error];
	[r release];
	
	STAssertNil(error, @"error should be nil: %@", error);
	
	//even though user #115730 has been active in more than 70 tags, only 70 are returned at a time (by default, max is 100)
	STAssertTrue([userTags count] == 70, @"incorrect number of badges (%ld)", [userTags count]);
}

@end
