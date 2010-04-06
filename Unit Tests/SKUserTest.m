//
//  SKUserTest.m
//  StackKit
//
//  Created by Dave DeLong on 1/25/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "SKUserTest.h"
#import "SKTestConstants.h"
#import <StackKit/StackKit.h>
#import "SKFetchRequest+Private.h"

@implementation SKUserTest

- (void) testUserAPICall {
	SKSite * site = [[SKSite alloc] initWithAPIURL:[NSURL URLWithString:SKTestAPISite]];
	
	NSString * expected = [NSString stringWithFormat:@"%@/%@/users/115730?key=%@", SKTestAPISite, SKAPIVersion, [site apiKey]];
	
	SKFetchRequest * request = [[SKFetchRequest alloc] initWithSite:site];
	[request setEntity:[SKUser class]];
	[request setPredicate:[NSPredicate predicateWithFormat:@"%K = %@", SKUserID, [NSNumber numberWithInt:115730]]];
	
	NSURL * requestURL = [request apiCallWithError:nil];
	STAssertEqualObjects([requestURL absoluteString], expected, @"request did not generate appropriate URL");
	
	NSArray * results = [site executeFetchRequest:request error:nil];
	STAssertTrue([results count] == 1, @"request should return 1 object");
	
	SKUser * davedelong = [results objectAtIndex:0];
	STAssertEqualObjects([davedelong displayName], @"Dave DeLong", @"incorrect user displayName");
	STAssertEqualObjects([davedelong userID], [NSNumber numberWithInt:115730], @"incorrect user id");
	
	SKUser * test = [site userWithID:[NSNumber numberWithInt:115730]];
	STAssertEqualObjects(davedelong, test, @"user does not match itself");
	
	STAssertEquals([davedelong acceptRate], 100.0f, @"accept rate does not match");
	
	[site release];
}
 

- (void) testOldestUsers {
	SKSite * site = [SKSite stackoverflowSite];
	
	SKFetchRequest * request = [[SKFetchRequest alloc] init];
	[request setEntity:[SKUser class]];
	[request setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:SKUserCreationDate ascending:YES]]];
	[request setFetchLimit:10];
	
	NSError * error = nil;
	NSArray * users = [site executeFetchRequest:request error:&error];
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
	STAssertTrue([users count] == 10, @"only 10 users should've been fetched");
	
	STAssertNil(error, @"error should be nil");
}

- (void) testUserFilter {
	SKSite * site = [SKSite stackoverflowSite];
	
	SKFetchRequest * request = [[SKFetchRequest alloc] init];
	[request setEntity:[SKUser class]];
	[request setPredicate:[NSPredicate predicateWithFormat:@"%K CONTAINS %@", SKUserDisplayName, @"DeLong"]];
	
	NSError * error = nil;
	NSArray * matches = [site executeFetchRequest:request error:&error];
	[request release];
	STAssertNil(error, @"error should be nil");
	STAssertTrue([matches count] == 1, @"matches should only have 1 object");
	
	SKUser * davedelong = [matches objectAtIndex:0];
	STAssertEqualObjects([davedelong userID], [NSNumber numberWithInt:115730], @"non-matching user id");
}
@end
