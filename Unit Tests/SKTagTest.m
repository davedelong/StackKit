//
//  SKTagTest.m
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
	[r setSortDescriptor:[[[NSSortDescriptor alloc] initWithKey:SKTagCount ascending:NO] autorelease]];
	
	NSError * error = nil;
	NSArray * popular = [site executeSynchronousFetchRequest:r error:&error];
	[r release];
	
	STAssertNil(error, @"error should be nil: %@", error);
	
	NSNumber * previousCount = nil;
	for (SKTag * tag in popular) {
		STAssertTrue([previousCount integerValue] >= [[tag numberOfTaggedQuestions] integerValue], @"out-of-order tag! (%@ >=? %@)", previousCount, [tag numberOfTaggedQuestions]);
		previousCount = [tag numberOfTaggedQuestions];
	}
}

- (void) testName {
	SKSite * site = [SKSite stackoverflowSite];
	
	NSLog(@"request");
	SKFetchRequest * r = [[SKFetchRequest alloc] init];
	NSLog(@"entity");
	[r setEntity:[SKTag class]];
	NSLog(@"sort");
	[r setSortDescriptor:[[[NSSortDescriptor alloc] initWithKey:SKTagName ascending:YES] autorelease]];
	
	NSError * error = nil;
	NSLog(@"execute");
	NSArray * popular = [site executeSynchronousFetchRequest:r error:&error];
	NSLog(@"release");
	[r release];
	
	NSLog(@"%@", error);
	
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
