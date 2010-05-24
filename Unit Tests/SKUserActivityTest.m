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
	NSArray * activity = [site executeSynchronousFetchRequest:r error:&error];
	[r release];
	
	STAssertNil(error, @"error should be nil");
	
	STAssertTrue([activity count] > 0, @"activity should be non-empty");
}

- (void) testUserActivityBetweenDates {
	SKSite * site = [SKSite stackoverflowSite];
	
	SKFetchRequest * r = [[SKFetchRequest alloc] init];
	[r setEntity:[SKUserActivity class]];
	[r setPredicate:[NSPredicate predicateWithFormat:@"%K = %@ AND %K >= %@ AND %K <= %@", 
					 SKUserID, @"115730",
					 SKUserActivityCreationDate, [NSDate dateWithString:@"2010-04-01 00:00:00 -0000"],
					 SKUserActivityCreationDate, [NSDate dateWithString:@"2010-04-04 00:00:00 -0600"],
					 nil]];
	[r setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:SKUserActivityCreationDate ascending:YES]]];
	
	NSError * error = nil;
	NSArray * activity = [site executeSynchronousFetchRequest:r error:&error];
	[r release];
	
	STAssertNil(error, @"error should be nil: %@", error);
	
	NSArray * actualDescriptions = [activity valueForKey:@"activityDescription"];
	NSArray * expectedDescriptions = [NSArray arrayWithObjects:/**@"Is it possible to filter an NSArray by class?",
									  @"Rounded Rect UIButton without the border",
									  @"The 10.6.3 os x update broke simulated key-presses for Nestopia.",
									  @"strchr in objective C?",
									  @"Get currently selected item in Mac UI",
									  @"UITabBar customization",
									  @"Class variable defined at @implementation rather than @interface?",**/
									  @"MobileMe Connection - Cocoa",
									  @"Options for Cocoa-based text editor",
									  nil];
	
	STAssertEqualObjects(actualDescriptions, expectedDescriptions, @"actual descriptions do not match (%@)", actualDescriptions);
}

@end
