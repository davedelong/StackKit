//
//  SKFetchRequest.m
//  StackKit
//
//  Created by Dave DeLong on 3/29/10.
//  Copyright 2010 Home. All rights reserved.
//
#import "StackKit_Internal.h"

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
	
	Class fetchEntity = [self entity];
	if ([[[self class] validFetchEntities] containsObject:fetchEntity] == NO) {
		//invalid entity
		if (error != nil) {
			*error = [NSError errorWithDomain:@"stackkit" code:0 userInfo:nil];
		}
		return nil;
	}
	
	return [fetchEntity apiCallForFetchRequest:self error:error];
}

- (NSArray *) executeWithError:(NSError **)error {
	NSURL * fetchURL = [self apiCallWithError:error];
	if (error != nil && *error != nil) { return nil; }
	if (fetchURL == nil) { return nil; }
	
	NSURLRequest * urlRequest = [NSURLRequest requestWithURL:fetchURL];
	NSURLResponse * response = nil;
	NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:error];
	if (error != nil && *error != nil) { return nil; }
	NSString * responseString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
	
	NSDictionary * responseObjects = [responseString JSONValue];
	assert([responseObjects isKindOfClass:[NSDictionary class]]);
	assert([[responseObjects allKeys] count] == 1);
	id dataObject = [responseObjects objectForKey:[[responseObjects allKeys] objectAtIndex:0]];
	
	NSMutableArray * objects = [NSMutableArray array];	
	
	if ([dataObject isKindOfClass:[NSArray class]]) {
		for (NSDictionary * dataDictionary in dataObject) {
			SKObject * object = [[self entity] objectWithSite:[self site] dictionaryRepresentation:dataDictionary];
			[objects addObject:object];
		}
	} else if ([dataObject isKindOfClass:[NSDictionary class]]) {
		SKObject * object = [[self entity] objectWithSite:[self site] dictionaryRepresentation:dataObject];
		[objects addObject:object];
	}
	
	//TODO: filter the matches based on [self predicate]
	//TODO: sort the matches based on [self sortDescriptors]
	
	return objects;
}

- (void) setFetchLimit:(NSUInteger)newLimit {
	if (newLimit > SKPageSizeLimitMax) {
		newLimit = SKPageSizeLimitMax;
	}
	fetchLimit = newLimit;
}

@end
