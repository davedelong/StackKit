//
//  SKUserTest.m
//  StackKit
//
//  Created by Dave DeLong on 1/25/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "SKUserTest.h"
#import <StackKit/StackKit.h>


@implementation SKUserTest

- (void) testUserAPICall {
	SKSite * site = [[SKSite alloc] initWithAPIURL:[NSURL URLWithString:@"http://api.stackoverflow.com"] APIKey:@"knockknock"];
	
	NSString * expected = [NSString stringWithFormat:@"http://api.stackoverflow.com/users/115730?key=%@", [site apiKey]];
	
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
}
 
@end
