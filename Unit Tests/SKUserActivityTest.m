//
//  SKUserActivityTest.m
//  StackKit
//
//  Created by Dave DeLong on 4/5/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "SKUserActivityTest.h"
#import <StackKit/StackKit.h>

@implementation SKUserActivityTest

- (void) testUserActivity {
	SKSite * site = [SKSite stackoverflowSite];
	
	SKFetchRequest * r = [[SKFetchRequest alloc] init];
	[r setEntity:[SKUserActivity class]];
	[r setPredicate:[NSPredicate predicateWithFormat:@"%K = %@", SKUserID, @"115730"]];
	
	NSError * error = nil;
	NSArray * activity = [site executeFetchRequest:r error:&error];
	[r release];
	
	STAssertNil(error, @"error should be nil");
	
	NSLog(@"%@", activity);
}

- (void) testUserActivityBetweenDates {
	SKSite * site = [SKSite stackoverflowSite];
	
	SKFetchRequest * r = [[SKFetchRequest alloc] init];
	[r setEntity:[SKUserActivity class]];
	[r setPredicate:[NSPredicate predicateWithFormat:@"%K = %@ AND %K >= %@ AND %K <= %@", 
					 SKUserID, @"115730",
					 SKUserActivityCreationDate, [NSDate dateWithString:@"2010-01-01 00:00:00 -0000"],
					 SKUserActivityCreationDate, [NSDate dateWithString:@"2010-01-02 00:00:00 -0000"],
					 nil]];
	
	NSError * error = nil;
	NSArray * activity = [site executeFetchRequest:r error:&error];
	[r release];
	
	STAssertNil(error, @"error should be nil");
	
	NSLog(@"%@", [activity valueForKey:SKUserActivityCreationDate]);
}

@end
