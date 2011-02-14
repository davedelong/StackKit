//
//  SKCommentTest.m
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

#import "SKCommentTest.h"
#import "SKTestConstants.h"
#import <StackKit/StackKit.h>

@implementation SKCommentTest

- (void) testIndividualComment {
	SKSite * s = [[SKSiteManager sharedManager] stackOverflowSite];
	
	SKFetchRequest * r = [[SKFetchRequest alloc] init];
	[r setEntity:[SKComment class]];
	[r setPredicate:[NSPredicate predicateWithFormat:@"postID = %d", 3056814]];
	
	NSArray * results = [s executeSynchronousFetchRequest:r];
	
	STAssertNil([r error], @"Error should be nil: %@", [r error]);
	STAssertTrue([results count] == 1, @"Unexpected number of results: %@", results);
	
	SKComment * comment = [results objectAtIndex:0];
	
	STAssertEqualObjects([[comment owner] userID], [NSNumber numberWithInt:115730], @"Unexpected post owner: %@", [[comment owner] userID]);
	[r release];
}

- (void) testMultipleComments {
	SKSite * s = [[SKSiteManager sharedManager] stackOverflowSite];
	
	SKFetchRequest * r = [[SKFetchRequest alloc] init];
	[r setEntity:[SKComment class]];
	[r setPredicate:[NSPredicate predicateWithFormat:@"postID = %@", [NSArray arrayWithObjects:@"3056814",@"2520617", nil]]];
	
	NSArray * results = [s executeSynchronousFetchRequest:r];
	
	STAssertNil([r error], @"Error should be nil: %@", [r error]);
	STAssertTrue([results count] == 2, @"Unexpected number of results: %@", results);
	[r release];
	
	SKComment * comment = [results objectAtIndex:0];
	
	STAssertEqualObjects([[comment owner] userID], [NSNumber numberWithInt:115730], @"Unexpected post owner: %@", [[comment owner] userID]);
	
	comment = [results objectAtIndex:1];
	
	STAssertEqualObjects([[comment owner] userID], [NSNumber numberWithInt:267256], @"Unexpected post owner: %@", [[comment owner] userID]);
	
}

- (void) testUserComments {
	SKSite * s = [[SKSiteManager sharedManager] stackOverflowSite];
	
	SKFetchRequest * r = [[SKFetchRequest alloc] init];
	[r setEntity:[SKComment class]];
	[r setPredicate:[NSPredicate predicateWithFormat:@"owner = %d", 115730]];
	
	NSArray * results = [s executeSynchronousFetchRequest:r];
	
	STAssertNil([r error], @"Error should be nil: %@", [r error]);
	STAssertTrue([results count] > 0, @"Unexpected number of results: %@", results);
	
	NSNumber * user = [NSNumber numberWithInt:115730];
	for (SKComment * comment in results) {
		STAssertEqualObjects([[comment owner] userID], user, @"Unexpected post owner: %@", [[comment owner] userID]);
	}
	[r release];
}

- (void) testUserCommentsInDateRange {
	SKSite * s = [[SKSiteManager sharedManager] stackOverflowSite];
	
	NSDate * fromDate = [NSDate dateWithNaturalLanguageString:@"1 Jan 2010"];
	NSDate * toDate = [NSDate dateWithNaturalLanguageString:@"3 Jan 2010"];
	
	SKFetchRequest * r = [[SKFetchRequest alloc] init];
	[r setEntity:[SKComment class]];
	[r setPredicate:[NSPredicate predicateWithFormat:@"owner = %d AND creationDate >= %@ AND creationDate <= %@", 115730, fromDate, toDate]];
	[r setSortDescriptor:[[[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:YES] autorelease]];
	
	NSArray * results = [s executeSynchronousFetchRequest:r];
	
	STAssertNil([r error], @"Error should be nil: %@", [r error]);
	STAssertTrue([results count] > 0, @"Unexpected number of results: %@", results);
	
	for (SKComment * comment in results) {
		NSDate * commentDate = [comment creationDate];
		STAssertTrue([[commentDate earlierDate:fromDate] isEqualToDate:fromDate], @"Unexpected creation date: %@", commentDate);
		STAssertTrue([[commentDate earlierDate:toDate] isEqualToDate:commentDate], @"Unexpected creation date: %@", commentDate);
	}
	[r release];
}

- (void) testUserCommentsInScoreRange {
	SKSite * s = [[SKSiteManager sharedManager] stackOverflowSite];
	
	int lowerScore = 3;
	int higherScore = 5;
	
	SKFetchRequest * r = [[SKFetchRequest alloc] init];
	[r setEntity:[SKComment class]];
	[r setPredicate:[NSPredicate predicateWithFormat:@"owner = %d AND score >= %d AND score <= %d", 115730, lowerScore, higherScore]];
	[r setSortDescriptor:[[[NSSortDescriptor alloc] initWithKey:@"score" ascending:NO] autorelease]];
	
	NSArray * results = [s executeSynchronousFetchRequest:r];
	
	STAssertNil([r error], @"Error should be nil: %@", [r error]);
	STAssertTrue([results count] > 0, @"Unexpected number of results: %@", results);
	
	for (SKComment * comment in results) {
		NSNumber * score = [comment score];
		STAssertTrue([score intValue] >= lowerScore, @"Unexpected score: %@", score);
		STAssertTrue([score intValue] <= higherScore, @"Unexpected score: %@", score);
	}
	[r release];
}

@end
