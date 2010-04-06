//
//  SKSiteTest.m
//  StackKit
//
//  Created by Dave DeLong on 4/4/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "SKSiteTest.h"
#import "SKTestConstants.h"
#import <StackKit/StackKit.h>

@implementation SKSiteTest

- (void) testStatistics {
	SKSite * site = [SKSite stackoverflowSite];
	
	NSDictionary * stats = [site statistics];
	
	NSLog(@"%@", stats);
	
	NSString * apiVersion = [[stats objectForKey:SKStatsAPIInfo] objectForKey:SKStatsAPIInfoVersion];
	STAssertEqualObjects(apiVersion, SKAPIVersion, @"API versions do not match!");
}

@end
