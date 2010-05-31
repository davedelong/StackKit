//
//  SKUserActivityTest.m
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
