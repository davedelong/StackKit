//
//  SKQuestionTest.m
//  StackKit
//
//  Created by Dave DeLong on 1/25/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "SKQuestionTest.h"
#import <StackKit/StackKit.h>

@implementation SKQuestionTest

- (void) testQuestion {
	SKSite * site = [[SKSite alloc] initWithAPIURL:[NSURL URLWithString:@"http://api.stackoverflow.com"]];
	
	SKQuestion * q = [[SKQuestion alloc] initWithSite:site postID:[NSNumber numberWithUnsignedInteger:1283419]];
	
	STAssertEqualObjects([q title], @"Valid use of accessors in init and dealloc methods?", @"Unexpected title");
	STAssertTrue([q voteCount] == 7, @"Unexpected vote count");
	STAssertTrue([q viewCount] == 269, @"Unexpected view count");
	STAssertTrue([q favoritedCount] == 2, @"Unexpected favorited count");
	STAssertTrue([q upVotes] == 7, @"Unexpected upvote count");
	STAssertTrue([q downVotes] == 0, @"Unexpected downvote count");
	
	[q release];
	[site release];
}

@end
