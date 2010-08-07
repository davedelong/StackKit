//
//  SKCommentTest.m
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

#import "SKCommentTest.h"
#import "SKTestConstants.h"
#import <StackKit/StackKit.h>

@implementation SKCommentTest

- (void) testIndividualComment {
	SKSite * s = [SKSite stackOverflowSite];
	
	SKFetchRequest * r = [[SKFetchRequest alloc] init];
	[r setEntity:[SKComment class]];
	[r setPredicate:[NSPredicate predicateWithFormat:@"%K = %d", SKCommentID, 3056814]];
	
	NSError * error = nil;
	NSArray * results = [s executeSynchronousFetchRequest:r error:&error];
	[r release];
	
	STAssertNil(error, @"Error should be nil: %@", error);
	STAssertTrue([results count] == 1, @"Unexpected number of results: %@", results);
	
	SKComment * comment = [results objectAtIndex:0];
	
	STAssertEqualObjects([comment ownerID], [NSNumber numberWithInt:115730], @"Unexpected post owner: %@", [comment ownerID]);
}

- (void) testMultipleComments {
	SKSite * s = [SKSite stackOverflowSite];
	
	SKFetchRequest * r = [[SKFetchRequest alloc] init];
	[r setEntity:[SKComment class]];
	[r setPredicate:[NSPredicate predicateWithFormat:@"%K = %@", SKCommentID, [NSArray arrayWithObjects:@"3056814",@"2520617", nil]]];
	
	NSError * error = nil;
	NSArray * results = [s executeSynchronousFetchRequest:r error:&error];
	[r release];
	
	STAssertNil(error, @"Error should be nil: %@", error);
	STAssertTrue([results count] == 2, @"Unexpected number of results: %@", results);
	
	SKComment * comment = [results objectAtIndex:0];
	
	STAssertEqualObjects([comment ownerID], [NSNumber numberWithInt:115730], @"Unexpected post owner: %@", [comment ownerID]);
	
	comment = [results objectAtIndex:1];
	
	STAssertEqualObjects([comment ownerID], [NSNumber numberWithInt:267256], @"Unexpected post owner: %@", [comment ownerID]);
	
}

- (void) testUserComments {
	SKSite * s = [SKSite stackOverflowSite];
	
	SKFetchRequest * r = [[SKFetchRequest alloc] init];
	[r setEntity:[SKComment class]];
	[r setPredicate:[NSPredicate predicateWithFormat:@"%K = %d", SKPostOwner, 115730]];
	
	NSError * error = nil;
	NSArray * results = [s executeSynchronousFetchRequest:r error:&error];
	[r release];
	
	STAssertNil(error, @"Error should be nil: %@", error);
	STAssertTrue([results count] > 0, @"Unexpected number of results: %@", results);
	
	NSNumber * user = [NSNumber numberWithInt:115730];
	for (SKComment * comment in results) {
		STAssertEqualObjects([comment ownerID], user, @"Unexpected post owner: %@", [comment ownerID]);
	}
}

- (void) testUserCommentsInDateRange {
	SKSite * s = [SKSite stackOverflowSite];
	
	NSDate * fromDate = [NSDate dateWithNaturalLanguageString:@"1 Jan 2010"];
	NSDate * toDate = [NSDate dateWithNaturalLanguageString:@"3 Jan 2010"];
	
	SKFetchRequest * r = [[SKFetchRequest alloc] init];
	[r setEntity:[SKComment class]];
	[r setPredicate:[NSPredicate predicateWithFormat:@"%K = %d AND %K >= %@ AND %K <= %@", SKCommentOwner, 115730, SKCommentCreationDate, fromDate, SKCommentCreationDate, toDate]];
	[r setSortDescriptor:[[[NSSortDescriptor alloc] initWithKey:SKCommentCreationDate ascending:YES] autorelease]];
	
	NSError * error = nil;
	NSArray * results = [s executeSynchronousFetchRequest:r error:&error];
	[r release];
	
	STAssertNil(error, @"Error should be nil: %@", error);
	STAssertTrue([results count] > 0, @"Unexpected number of results: %@", results);
	
	for (SKComment * comment in results) {
		NSDate * commentDate = [comment creationDate];
		STAssertTrue([[commentDate earlierDate:fromDate] isEqualToDate:fromDate], @"Unexpected creation date: %@", commentDate);
		STAssertTrue([[commentDate earlierDate:toDate] isEqualToDate:commentDate], @"Unexpected creation date: %@", commentDate);
	}
}

- (void) testUserCommentsInScoreRange {
	SKSite * s = [SKSite stackOverflowSite];
	
	int lowerScore = 3;
	int higherScore = 5;
	
	SKFetchRequest * r = [[SKFetchRequest alloc] init];
	[r setEntity:[SKComment class]];
	[r setPredicate:[NSPredicate predicateWithFormat:@"%K = %d AND %K >= %d AND %K <= %d", SKCommentOwner, 115730, SKCommentScore, lowerScore, SKCommentScore, higherScore]];
	[r setSortDescriptor:[[[NSSortDescriptor alloc] initWithKey:SKCommentScore ascending:NO] autorelease]];
	
	NSError * error = nil;
	NSArray * results = [s executeSynchronousFetchRequest:r error:&error];
	[r release];
	
	STAssertNil(error, @"Error should be nil: %@", error);
	STAssertTrue([results count] > 0, @"Unexpected number of results: %@", results);
	
	for (SKComment * comment in results) {
		NSNumber * score = [comment score];
		STAssertTrue([score intValue] >= lowerScore, @"Unexpected score: %@", score);
		STAssertTrue([score intValue] <= higherScore, @"Unexpected score: %@", score);
	}
}

@end
