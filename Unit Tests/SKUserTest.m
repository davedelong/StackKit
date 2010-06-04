//
//  SKUserTest.m
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

#import "SKUserTest.h"
#import "SKTestConstants.h"
#import <StackKit/StackKit.h>
#import "SKFetchRequest+Private.h"

@implementation SKUserTest

- (void) testUserAPICall {
	SKSite * site = [SKSite stackoverflowSite];
	
	NSString * expected = [NSString stringWithFormat:@"%@/%@/users/115730?key=%@", SKTestAPISite, SKAPIVersion, [site APIKey]];
	
	SKFetchRequest * request = [[SKFetchRequest alloc] initWithSite:site];
	[request setEntity:[SKUser class]];
	[request setPredicate:[NSPredicate predicateWithFormat:@"%K = %@", SKUserID, [NSNumber numberWithInt:115730]]];
	
	NSURL * requestURL = [request apiCall];
	STAssertEqualObjects([requestURL absoluteString], expected, @"request did not generate appropriate URL");
	
	NSError * error = nil;
	NSArray * results = [site executeSynchronousFetchRequest:request error:&error];
	STAssertTrue([results count] == 1, @"request should return 1 object");
	
	SKUser * davedelong = [results objectAtIndex:0];
	STAssertEqualObjects([davedelong displayName], @"Dave DeLong", @"incorrect user displayName");
	STAssertEqualObjects([davedelong userID], [NSNumber numberWithInt:115730], @"incorrect user id");
	
	SKUser * test = [site userWithID:[NSNumber numberWithInt:115730]];
	STAssertEqualObjects(davedelong, test, @"user does not match itself");
	
	STAssertEquals([[davedelong acceptRate] floatValue], 100.0f, @"accept rate does not match");
}
 

- (void) testOldestUsers {
	SKSite * site = [SKSite stackoverflowSite];
	
	SKFetchRequest * request = [[SKFetchRequest alloc] init];
	[request setEntity:[SKUser class]];
	[request setSortDescriptor:[[[NSSortDescriptor alloc] initWithKey:SKUserCreationDate ascending:YES] autorelease]];
	[request setFetchLimit:10];
	
	NSError * error = nil;
	NSArray * users = [site executeSynchronousFetchRequest:request error:&error];
	NSLog(@"%@", error);
	[request release];
	
	NSArray * oldest = [NSArray arrayWithObjects:@"Community",
						@"Jarrod Dixon",
						@"Jeff Atwood",
						@"Geoff Dalgas",
						@"Joel Spolsky",
						@"Jon Galloway",
						@"Eggs McLaren",
						@"Kevin Dente",
						@"Sneakers O'Toole",
						@"Chris Jester-Young",
						nil];
	
	NSArray * returnedDisplayNames = [users valueForKey:SKUserDisplayName];
	STAssertEqualObjects(returnedDisplayNames, oldest, @"oldest users do not match");
	STAssertTrue([users count] == 10, @"only 10 users should've been fetched: %@", users);
	
	STAssertNil(error, @"error should be nil: %@", error);
}

- (void) testUserFilter {
	SKSite * site = [SKSite stackoverflowSite];
	
	SKFetchRequest * request = [[SKFetchRequest alloc] init];
	[request setEntity:[SKUser class]];
	[request setPredicate:[NSPredicate predicateWithFormat:@"%K CONTAINS %@", SKUserDisplayName, @"DeLong"]];
	
	NSError * error = nil;
	NSArray * matches = [site executeSynchronousFetchRequest:request error:&error];
	[request release];
	STAssertNil(error, @"error should be nil");
	STAssertTrue([matches count] == 1, @"matches should only have 1 object");
	
	SKUser * davedelong = [matches objectAtIndex:0];
	STAssertEqualObjects([davedelong userID], [NSNumber numberWithInt:115730], @"non-matching user id");
}
@end
