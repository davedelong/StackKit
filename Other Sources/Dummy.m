//
//  Dummy.m
//  StackKit
//
//  Created by Dave DeLong on 1/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StackKit/StackKit.h>

int main(int argc, char* argv[]) {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	SKSite * s = [SKSite stackOverflowSite];
	SKFetchRequest * r = [[SKFetchRequest alloc] init];
	[r setEntity:[SKAnswer class]];
	[r setPredicate:[NSPredicate predicateWithFormat:@"%K = %d", SKAnswerOwner, 1234]];
	[r setSortDescriptor:[[[NSSortDescriptor alloc] initWithKey:SKAnswerCreationDate ascending:YES] autorelease]];
	[r setSite:s];
	
	NSArray * a = [NSArray arrayWithObjects:
				   NSClassFromString(@"_SKRequestBuilderAnswersByID"),
				   NSClassFromString(@"_SKRequestBuilderAnswersForQuestion"),
				   NSClassFromString(@"_SKRequestBuilderAnswersForUser"),
				   nil];
	NSLog(@"%@", a);
	NSLog(@"%@", [a valueForKey:@"allRecognizedSortDescriptorKeys"]);
	
	NSError * e = nil;
	Class builder = NSClassFromString(@"SKRequestBuilder");
	NSURL * u = [builder URLForFetchRequest:r error:&e];
	
	NSLog(@"error: %@", e);
	NSLog(@"url: %@", u);
	
	[r release];
	
	[pool drain];
	return 0;
}