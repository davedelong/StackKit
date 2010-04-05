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

- (id) initWithSite:(SKSite *)aSite {
	if (self = [super initWithSite:aSite]) {
		fetchLimit = SKPageSizeLimitMax;
		fetchOffset = 0;
	}
	return self;
}

- (id) init {
	return [self initWithSite:nil];
}

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
			*error = [NSError errorWithDomain:SKErrorDomain code:SKErrorCodeInvalidEntity userInfo:nil];
		}
		return nil;
	}
	
	return [fetchEntity apiCallForFetchRequest:self error:error];
}

- (NSArray *) executeWithError:(NSError **)error {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	NSURL * fetchURL = [self apiCallWithError:error];
	if (error != nil && *error != nil) { goto errorCleanup; }
	if (fetchURL == nil) { goto errorCleanup; }
	
	NSURLRequest * urlRequest = [NSURLRequest requestWithURL:fetchURL];
	NSURLResponse * response = nil;
	NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:error];
	if (error != nil && *error != nil) { goto errorCleanup; }
	NSString * responseString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
	
	NSDictionary * responseObjects = [responseString JSONValue];
	assert([responseObjects isKindOfClass:[NSDictionary class]]);
	assert([[responseObjects allKeys] count] == 1);
	id dataObject = [responseObjects objectForKey:[[responseObjects allKeys] objectAtIndex:0]];
	
	NSMutableArray * objects = [[NSMutableArray alloc] init];	
	
	if ([dataObject isKindOfClass:[NSArray class]]) {
		for (NSDictionary * dataDictionary in dataObject) {
			SKObject * object = [[self entity] objectWithSite:[self site] dictionaryRepresentation:dataDictionary];
			[objects addObject:object];
		}
	} else if ([dataObject isKindOfClass:[NSDictionary class]]) {
		SKObject * object = [[self entity] objectWithSite:[self site] dictionaryRepresentation:dataObject];
		[objects addObject:object];
	}
	
	//the class might need to remove certain components of the predice
	//for example, we can request SKBadges where SKUserID = value,
	//but applying that predicate directly would empty the array, since SKBadges don't have an SKUserID ivar
	//and adding it/overriding the valueForKey: would be really complicated
	predicate = [[self entity] updatedPredicateForFetchRequest:self];
	
	if (predicate != nil) {
		[objects filterUsingPredicate:predicate];
	}
	
	//we also need to remove any unnecessary sort descriptors
	NSArray * sortDescriptors = [[self entity] updatedSortDescriptorsForFetchRequest:self];
	if (sortDescriptors != nil && [sortDescriptors count] > 0) {
		[objects sortUsingDescriptors:sortDescriptors];
	}
	
	[pool release];
	return [objects autorelease];
	
errorCleanup:
	[pool release];
	return nil;
}

- (void) setFetchLimit:(NSUInteger)newLimit {
	if (newLimit > SKPageSizeLimitMax) {
		newLimit = SKPageSizeLimitMax;
	}
	fetchLimit = newLimit;
}

@end
