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

- (void) testFlair {
	SKSite * site = [[SKSite alloc] initWithURL:[NSURL URLWithString:@"http://stackoverflow.com"]];
	
	SKUser * user = [site userWithID:@"115730"];
	
	STAssertNotNil(user, @"Error retrieving user");
	STAssertEqualObjects(@"Dave DeLong", [user displayName], @"Unexpected user name");
	STAssertTrue([user reputation] >= 12250, @"Unexpected user reputation");
	STAssertEqualObjects([NSURL URLWithString:@"http://stackoverflow.com/users/115730/dave-delong"], [user profileURL], @"Unexpected profile url");
	
	[site release];
}

- (void) testMetaFlair {
	SKSite * site = [[SKSite alloc] initWithURL:[NSURL URLWithString:@"http://meta.stackoverflow.com"]];
	
	SKUser * user = [site userWithID:@"135683"];
	
	STAssertNotNil(user, @"Error retrieving user");
	STAssertEqualObjects(@"Dave DeLong", [user displayName], @"Unexpected user name");
	STAssertTrue([user reputation] == 135, @"Unexpected user reputation");
	STAssertEqualObjects([NSURL URLWithString:@"http://meta.stackoverflow.com/users/135683/dave-delong"], [user profileURL], @"Unexpected profile url");
	
	[site release];
}

- (void) testFavorites {
	SKSite * site = [[SKSite alloc] initWithURL:[NSURL URLWithString:@"http://stackoverflow.com"]];
	
	SKUser * user = [site userWithID:@"115730"];
	NSSet * favorites = [user favorites];
	
	NSLog(@"Favorites: %@", favorites);
}

@end
