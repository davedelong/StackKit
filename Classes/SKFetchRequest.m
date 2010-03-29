//
//  SKFetchRequest.m
//  StackKit
//
//  Created by Dave DeLong on 3/29/10.
//  Copyright 2010 Home. All rights reserved.
//
#import "StackKit.h"
#import "SKFetchRequest.h"
#import "SKObject.h"
#import "SKObject+Private.h"

@implementation SKFetchRequest
@synthesize entity;
@synthesize sortDescriptors;
@synthesize fetchLimit;
@synthesize fetchOffset;
@synthesize predicate;

+ (NSArray *) validFetchEntities {
	return [NSArray arrayWithObjects:
			[SKUser class], 
			[SKTag class], 
			[SKBadge class], 
			[SKQuestion class], 
			[SKAnswer class], 
			[SKComment class], 
			nil];
}

- (NSURL *) apiCallWithError:(NSError **)error {
	if ([self site] == nil) { return nil; }
	
	//this is the base
	NSURL * apiURL = [[self site] apiURL];
	Class fetchEntity = [self entity];
	
	NSURL * apiCall = [(SKObject *)fetchEntity apiCallForFetchRequest:self error:error];
	
	return apiCall;
}

@end
