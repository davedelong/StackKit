//
//  SKQuestionTest.m
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

#import "SKQuestionTest.h"
#import "SKTestConstants.h"
#import <StackKit/StackKit.h>

@implementation SKQuestionTest

- (void) setUp {
	didReceiveCallback = NO;
}

- (void) tearDown {
	didReceiveCallback = NO;
}

- (void) testSingleQuestion {
	SKSite * site = [SKSite stackOverflowSite];
	
	SKFetchRequest * r = [[SKFetchRequest alloc] init];
	[r setEntity:[SKQuestion class]];
	[r setPredicate:[NSPredicate predicateWithFormat:@"%K = %d", SKQuestionID, 1283419]];
	
	NSError * e = nil;
	NSArray * matches = [site executeSynchronousFetchRequest:r error:&e];
	[r release];
	
	STAssertTrue([matches count] > 0, @"Expecting 1 question");
	STAssertNil(e, @"Expecting nil error: %@", e);
	
	SKQuestion * q = [matches objectAtIndex:0];
	
	STAssertEqualObjects([q title], @"Valid use of accessors in init and dealloc methods?", @"Unexpected title");
	STAssertTrue([[q score] intValue] == 7, @"Unexpected vote count");
	STAssertTrue([[q viewCount] intValue] > 0, @"Unexpected view count");
	STAssertTrue([[q favoriteCount] intValue] > 0, @"Unexpected favorited count");
	STAssertTrue([[q upVotes] intValue] == 7, @"Unexpected upvote count");
	STAssertTrue([[q downVotes] intValue] == 0, @"Unexpected downvote count");
}

- (void) testTaggedQuestions {
	SKSite * s = [SKSite stackOverflowSite];
	
	SKFetchRequest * r = [[SKFetchRequest alloc] init];
	[r setEntity:[SKQuestion class]];
	[r setPredicate:[NSPredicate predicateWithFormat:@"%K CONTAINS %@", SKQuestionTags, @"cocoa"]];
	
	NSError * e = nil;
	NSArray * results = [s executeSynchronousFetchRequest:r error:&e];
	
	for (SKQuestion * q in results) {
		
	}
}

- (void) testQuestionSearch {
	SKSite * s = [SKSite stackOverflowSite];
	
	SKFetchRequest * r = [[SKFetchRequest alloc] init];
	[r setEntity:[SKQuestion class]];
	[r setPredicate:[NSPredicate predicateWithFormat:@"%K CONTAINS %@", SKQuestionTitle, @"Constants by another name"]];
	
	NSError * e = nil;
	NSArray * results = [s executeSynchronousFetchRequest:r error:&e];
	[r release];
	
	STAssertNil(e, @"Error should be nil: %@", e);
	STAssertTrue([results count] > 0, @"expecting at least 1 result");
	
	SKQuestion * q = [results objectAtIndex:0];
	
	STAssertEqualObjects([q ownerID], [NSNumber numberWithInt:115730], @"Owner should be #115730: %@", [q ownerID]);
}

- (void) testAllQuestions {
	SKSite * s = [SKSite stackOverflowSite];
	
	SKFetchRequest * r = [[SKFetchRequest alloc] init];
	[r setEntity:[SKQuestion class]];
	[r setSortDescriptor:[[[NSSortDescriptor alloc] initWithKey:SKQuestionCreationDate ascending:NO] autorelease]];
	[r setFetchLimit:10];
	
	NSError * e = nil;
	NSArray * results = [s executeSynchronousFetchRequest:r error:&e];
	[r release];
	
	STAssertNil(e, @"Error should be nil: %@", e);
	STAssertTrue([results count] == 10, @"expecting 10 results; got %d", [results count]);
	
	NSDate * previous = [NSDate distantFuture];
	for (SKQuestion * q in results) {
		NSDate * qDate = [q creationDate];
		STAssertTrue([[qDate laterDate:previous] isEqualToDate:previous], @"%@ is earlier than %@", previous, qDate);
		previous = qDate;
	}
}

- (void) testAsynchronousQuestion {
	SKSite * s = [SKSite stackOverflowSite];
	
	SKFetchRequest * r = [[SKFetchRequest alloc] init];
	[r setEntity:[SKQuestion class]];
	[r setPredicate:[NSPredicate predicateWithFormat:@"%K = %d", SKQuestionID, 3145955]];
	[r setDelegate:self];
	[s executeFetchRequest:r];
	
	while (didReceiveCallback == NO) {
		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
	}
	
	STAssertNil([r error], @"Fetch request error should be nil: %@", [r error]);
	
	[r release];
}

- (void)fetchRequest:(SKFetchRequest *)request didFailWithError:(NSError *)error {
	NSLog(@"failed: %@", error);
	didReceiveCallback = YES;
}

- (void) fetchRequest:(SKFetchRequest *)request didReturnResults:(NSArray *)results {
	NSLog(@"returned: %@", results);
	didReceiveCallback = YES;
}

@end
