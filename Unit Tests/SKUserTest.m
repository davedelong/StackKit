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
	[request setPredicate:[NSPredicate predicateWithFormat:@"%K = %@", SKUserID, @"115730"]];
	
	NSURL * requestURL = [request apiCallWithError:nil];
	STAssertEqualObjects([requestURL absoluteString], expected, @"request did not generate appropriate URL");
}

- (void) testFlair {
	SKSite * site = [[SKSite alloc] initWithAPIURL:[NSURL URLWithString:@"http://api.stackoverflow.com"] APIKey:@"knockknock"];
	
	SKUser * user = [site userWithID:@"115730"];
	
	STAssertNotNil(user, @"Error retrieving user");
	STAssertEqualObjects(@"Dave DeLong", [user displayName], @"Unexpected user name");
	STAssertTrue([user reputation] >= 12250, @"Unexpected user reputation");
	STAssertEqualObjects([NSURL URLWithString:@"http://stackoverflow.com/users/115730/dave-delong"], [user profileURL], @"Unexpected profile url");
	
	[site release];
}

- (void) testMetaFlair {
	SKSite * site = [[SKSite alloc] initWithAPIURL:[NSURL URLWithString:@"http://api.stackoverflow.com"] APIKey:@"knockknock"];
	
	SKUser * user = [site userWithID:@"135683"];
	
	STAssertNotNil(user, @"Error retrieving user");
	STAssertEqualObjects(@"Dave DeLong", [user displayName], @"Unexpected user name");
	STAssertTrue([user reputation] == 135, @"Unexpected user reputation");
	STAssertEqualObjects([NSURL URLWithString:@"http://meta.stackoverflow.com/users/135683/dave-delong"], [user profileURL], @"Unexpected profile url");
	
	[site release];
}

- (void) testFavorites {
	SKSite * site = [[SKSite alloc] initWithAPIURL:[NSURL URLWithString:@"http://api.stackoverflow.com"] APIKey:@"knockknock"];
	
	SKUser * user = [site userWithID:@"115730"];
	NSSet * favorites = [user favorites];
	
	NSLog(@"Favorites: %@", favorites);
}

@end
