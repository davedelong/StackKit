//
//  SKSiteTest.m
//  StackKit
//
//  Created by Dave DeLong on 4/4/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "SKSiteTest.h"
#import <StackKit/StackKit.h>

@implementation SKSiteTest

- (void) testStatistics {
	SKSite * site = [[SKSite alloc] initWithAPIURL:[NSURL URLWithString:@"http://api.stackoverflow.com"]];
	
	NSDictionary * stats = [site statistics];
	
	NSString * apiVersion = [[stats objectForKey:SKStatsAPIInfo] objectForKey:SKStatsAPIInfoVersion];
	STAssertEqualObjects(apiVersion, SKAPIVersion, @"API versions do not match!");
	
	[site release];
}

@end
