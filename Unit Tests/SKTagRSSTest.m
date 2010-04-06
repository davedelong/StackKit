//
//  SKTagRSSTest.m
//  StackKit
//
//  Created by Mark Suman on 1/30/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "SKTagRSSTest.h"
#import "SKTestConstants.h"
#import <StackKit/StackKit.h>

@implementation SKTagRSSTest

- (void)setUp {
	
}

- (void)tearDown {
	
}
/**
 - (void)testFetchTagRSS {
 SKSite * site = [SKSite stackoverflowSite];
	SKTag * tag = [SKTag tagWithSite:site name:@"iphone"];
	SKTagRSS * tagRSS = [[SKTagRSS alloc] initWithSite:site tag:tag];

	STAssertNotNil(tagRSS, @"Error retrieving rss feed for %@",[tag name]);

	[tagRSS release];
}

 - (void)testParseQuestions {
 SKSite * site = [SKSite stackoverflowSite];
	SKTag * tag = [SKTag tagWithSite:site name:@"iphone"];
	SKTagRSS * tagRSS = [[SKTagRSS alloc] initWithSite:site tag:tag];
	
	// Call parse so it actually creates the SKQuestion objects from the RSS xml
	[tagRSS parse];
	
	STAssertNotNil(tagRSS, @"Error retrieving rss feed for %@",[tag name]);
	STAssertTrue([[tagRSS questions] count]>0,@"No questions were retrieved for the tag \"%@\"",[tag name]);

	[tagRSS release];
}

 - (void)testLatestQuestionFromRSS {
 SKSite * site = [SKSite stackoverflowSite];
	SKTag * tag = [SKTag tagWithSite:site name:@"iphone"];
	SKTagRSS * tagRSS = [[SKTagRSS alloc] initWithSite:site tag:tag];
	[tagRSS parse];
	
	STAssertNotNil([[[tagRSS questions] objectAtIndex:0] title],@"The title for the latest question is nil.");
	
	[tagRSS release];
}
**/
@end
