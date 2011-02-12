//
//  SKQuestionTest.m
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

#import "SKQuestionTest.h"
#import "SKTestConstants.h"
#import <StackKit/StackKit.h>

@implementation SKQuestionTest

- (void) testSingleQuestion {
	SKSite * site = [[SKSiteManager sharedManager] stackOverflowSite];
	
	SKFetchRequest * r = [[SKFetchRequest alloc] init];
	[r setEntity:[SKQuestion class]];
	[r setPredicate:[NSPredicate predicateWithFormat:@"postID = %d", 1283419]];
	
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
	STAssertNotNil([q body], @"question body shouldn't be nil");
	
	NSSet * expectedTagNames = [NSSet setWithObjects:@"objective-c",@"properties",@"accessors",@"initialization",@"dealloc", nil];
	NSSet * actualTagNames = [NSSet setWithArray:[[q tags] valueForKey:@"name"]];
	STAssertEqualObjects(expectedTagNames, actualTagNames, @"unexpected tags.  Expected %@, given %@", expectedTagNames, actualTagNames);
}

- (void) testMultipleQuestions {
	SKSite * site = [[SKSiteManager sharedManager] stackOverflowSite];
	
	NSArray* questionsToFetch = [NSArray arrayWithObjects:
								 @"4729906",
								 [NSNumber numberWithInt:3389487],
								 [NSNumber numberWithInt:1283419],
								 nil];
	
	SKFetchRequest * r = [[SKFetchRequest alloc] init];
	[r setEntity:[SKQuestion class]];
	[r setPredicate:[NSPredicate predicateWithFormat:@"postID = %@", questionsToFetch]];
	
	NSError * e = nil;
	NSArray * matches = [site executeSynchronousFetchRequest:r error:&e];
	[r release];
	
	STAssertTrue([matches count] == 3, @"Expecting 3 questions");
	STAssertNil(e, @"Expecting nil error: %@", e);
	
	SKQuestion * q = [matches objectAtIndex:0];
	STAssertTrue([[q questionID] isEqualToNumber:[NSNumber numberWithInt:4729906]], @"Unexpected question returned at index 0");
	
	q = [matches objectAtIndex:1];
	STAssertTrue([[q questionID] isEqualToNumber:[NSNumber numberWithInt:3389487]], @"Unexpected question returned at index 1");
	
	q = [matches objectAtIndex:2];
	STAssertEqualObjects([q title], @"Valid use of accessors in init and dealloc methods?", @"Unexpected title");
	STAssertTrue([[q score] intValue] == 7, @"Unexpected vote count");
	STAssertTrue([[q viewCount] intValue] > 0, @"Unexpected view count");
	STAssertTrue([[q favoriteCount] intValue] > 0, @"Unexpected favorited count");
	STAssertTrue([[q upVotes] intValue] == 7, @"Unexpected upvote count");
	STAssertTrue([[q downVotes] intValue] == 0, @"Unexpected downvote count");
	STAssertNotNil([q body], @"question body shouldn't be nil");
	
	NSSet * expectedTagNames = [NSSet setWithObjects:@"objective-c",@"properties",@"accessors",@"initialization",@"dealloc", nil];
	NSSet * actualTagNames = [NSSet setWithArray:[[q tags] valueForKey:@"name"]];
	STAssertEqualObjects(expectedTagNames, actualTagNames, @"unexpected tags.  Expected %@, given %@", expectedTagNames, actualTagNames);
}

- (void) testTaggedQuestions {
	SKSite * s = [[SKSiteManager sharedManager] stackOverflowSite];
	
	SKFetchRequest * r = [[SKFetchRequest alloc] init];
	[r setEntity:[SKQuestion class]];
	[r setPredicate:[NSPredicate predicateWithFormat:@"tags CONTAINS %@", @"cocoa"]];
	
	NSError * e = nil;
	NSArray * results = [s executeSynchronousFetchRequest:r error:&e];
	[r release];
	
	for (SKQuestion * q in results) {
		NSSet * questionTags = [[q tags] valueForKey:@"name"];
		STAssertTrue([questionTags containsObject:@"cocoa"], @"Question (%@) is not tagged with \"cocoa\": %@", q, [q tags]);
	}
}

- (void) testQuestionSearch {
	SKSite * s = [[SKSiteManager sharedManager] stackOverflowSite];
	
	SKFetchRequest * r = [[SKFetchRequest alloc] init];
	[r setEntity:[SKQuestion class]];
	[r setPredicate:[NSPredicate predicateWithFormat:@"title CONTAINS %@", @"Constants by another name"]];
	
	NSError * e = nil;
	NSArray * results = [s executeSynchronousFetchRequest:r error:&e];
	[r release];
	
	STAssertNil(e, @"Error should be nil: %@", e);
	STAssertTrue([results count] > 0, @"expecting at least 1 result");
	
	SKQuestion * q = [results objectAtIndex:0];
	
	STAssertEqualObjects([[q owner] userID], [NSNumber numberWithInt:115730], @"Owner should be #115730: %@", [[q owner] userID]);
}

- (void) testAllQuestions {
	SKSite * s = [[SKSiteManager sharedManager] stackOverflowSite];
	
	SKFetchRequest * r = [[SKFetchRequest alloc] init];
	[r setEntity:[SKQuestion class]];
	[r setSortDescriptor:[[[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:NO] autorelease]];
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

- (void) testUnansweredTaggedQuestions {
	SKSite * s = [[SKSiteManager sharedManager] stackOverflowSite];
	
	SKFetchRequest * r = [[SKFetchRequest alloc] init];
	[r setEntity:[SKQuestion class]];
	[r setPredicate:[NSPredicate predicateWithFormat:@"answers.@count = 0 AND tags CONTAINS (%@)", @"iphone"]];
	
	NSError * e = nil;
	NSArray * results = [s executeSynchronousFetchRequest:r error:&e];
	[r release];
	
	STAssertNil(e, @"Error should be nil: %@", e);
	
	for (SKQuestion * question in results) {
        for (SKAnswer *answer in [question answers]) {
            STAssertTrue([[answer score] intValue] == 0, @"question should have 0 answers.  has: %@", [answer score]);
        }
		
		NSArray * tagNames = [[question tags] valueForKey:@"name"];
		STAssertTrue([tagNames containsObject:@"iphone"], @"questions should have \"iphone\" tag");
	}
}

- (void) testAsynchronousQuestion {
	SKSite * s = [[SKSiteManager sharedManager] stackOverflowSite];
	
	SKFetchRequest * r = [[SKFetchRequest alloc] init];
	[r setEntity:[SKQuestion class]];
	[r setPredicate:[NSPredicate predicateWithFormat:@"postID = %d", 3145955]];
    
    [s executeFetchRequest:r withCompletionHandler:^(NSArray *objects) {
        didReceiveCallback = YES;
    }];
	
	while (didReceiveCallback == NO) {
		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
	}
	
	STAssertNil([r error], @"Fetch request error should be nil: %@", [r error]);
	
	[r release];
}

@end
