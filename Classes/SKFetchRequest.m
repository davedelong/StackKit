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

NSString * SKErrorResponseKey = @"error";
NSString * SKErrorCodeKey = @"code";
NSString * SKErrorMessageKey = @"message";

- (id) initWithSite:(SKSite *)aSite {
	if (self = [super initWithSite:aSite]) {
		fetchLimit = 0;
		fetchOffset = 0;
	}
	return self;
}

- (id) init {
	return [self initWithSite:nil];
}

- (void) dealloc {
	[sortDescriptors release];
	[predicate release];
	[super dealloc];
}

+ (NSArray *) validFetchEntities {
	return [NSArray arrayWithObjects:
			[SKUser class],
			[SKUserActivity class],
			[SKTag class], 
			[SKBadge class], 
			[SKQuestion class], 
			[SKAnswer class], 
			[SKComment class], 
			nil];
}

- (NSURL *) apiCallWithError:(NSError **)error {
	if ([self site] == nil) { return nil; }
	
	NSInteger errorCode = 0;
	NSDictionary * errorUserInfo = nil;
	
	Class fetchEntity = [self entity];
	if ([[[self class] validFetchEntities] containsObject:fetchEntity] == NO) {
		//invalid entity
		errorCode = SKErrorCodeInvalidEntity;
		
		NSString * errorMessage = [NSString stringWithFormat:@"%@ is not a valid fetch entity", fetchEntity];
		errorUserInfo = [NSDictionary dictionaryWithObject:errorMessage forKey:NSLocalizedDescriptionKey];
		goto errorExit;
	}
	
	//evalutate the predicate.  we're only going to allow a single level of compounding
	NSPredicate * p = [self predicate];
	if ([p isKindOfClass:[NSCompoundPredicate class]]) {
		//compound predicates can't have compound subpredicates
		if ([(NSCompoundPredicate *)p compoundPredicateType] != NSAndPredicateType) {
			errorCode = SKErrorCodeInvalidPredicate;
			NSString * errorMessage = @"Fetch predicates may only be simple comparison predicates or an AND of simple comparison predicates";
			errorUserInfo = [NSDictionary dictionaryWithObject:errorMessage forKey:NSLocalizedDescriptionKey];
			goto errorExit;
		}
		for (NSPredicate * subp in [(NSCompoundPredicate *)p subpredicates]) {
			if ([subp isKindOfClass:[NSCompoundPredicate class]]) {
				errorCode = SKErrorCodeInvalidPredicate;
				NSString * errorMessage = @"Fetch predicates may only be simple comparison predicates or an AND of simple comparison predicates";
				errorUserInfo = [NSDictionary dictionaryWithObject:errorMessage forKey:NSLocalizedDescriptionKey];
				goto errorExit;
			}
		}
	}
	
	//TODO: clean the predicate.  error if there are non-supported keys, and replace left expressions as appropriate
	
	//TODO: evaluate the sort descriptors.  error if there are non-supported keys, and replace keys as appropriate
	
	return [fetchEntity apiCallForFetchRequest:self error:error];
	
errorExit:
	if (error != nil && errorCode > 0) {
		*error = [NSError errorWithDomain:SKErrorDomain code:errorCode userInfo:errorUserInfo];
	}
	return nil;
}

- (NSArray *) executeWithError:(NSError **)error {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	NSMutableArray * objects = nil;
	NSURL * fetchURL = [self apiCallWithError:error];
	
	NSLog(@"fetching from: %@", fetchURL);
	
	if (error != nil && *error != nil) {
		[*error retain]; //retain the error so it's not destroyed when the pool is drained
		goto cleanup;
	}
	if (fetchURL == nil) { goto cleanup; }
	
	NSURLRequest * urlRequest = [NSURLRequest requestWithURL:fetchURL];
	NSURLResponse * response = nil;
	NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:error];
	if (error != nil && *error != nil) {
		[*error retain];
		goto cleanup;
	}
	NSString * responseString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
	
	NSDictionary * responseObjects = [responseString JSONValue];
	assert([responseObjects isKindOfClass:[NSDictionary class]]);
	assert([[responseObjects allKeys] count] == 1);
	
	//check for an error in the response
	NSDictionary * errorDictionary = [responseObjects objectForKey:SKErrorResponseKey];
	if (errorDictionary != nil) {
		//there was an error responding to the request
		NSNumber * errorCode = [errorDictionary objectForKey:SKErrorCodeKey];
		NSString * errorMessage = [errorDictionary objectForKey:SKErrorMessageKey];
		
		if (error != nil) {
			NSDictionary * userInfo = [NSDictionary dictionaryWithObject:errorMessage forKey:NSLocalizedDescriptionKey];
			userInfo = nil;
			*error = [[NSError alloc] initWithDomain:SKErrorDomain code:[errorCode integerValue] userInfo:userInfo];
			goto cleanup;
		}
	}
	
	id dataObject = [responseObjects objectForKey:[[responseObjects allKeys] objectAtIndex:0]];
	
	objects = [[NSMutableArray alloc] init];	
	
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
	NSPredicate * updatedPredicate = [[self entity] updatedPredicateForFetchRequest:self];
	if (updatedPredicate != nil) {
		[objects filterUsingPredicate:updatedPredicate];
	}
	
	//we also need to remove any unnecessary sort descriptors
	NSArray * updatedSortDescriptors = [[self entity] updatedSortDescriptorsForFetchRequest:self];
	if (updatedSortDescriptors != nil && [updatedSortDescriptors count] > 0) {
		[objects sortUsingDescriptors:updatedSortDescriptors];
	}
	
cleanup:
	[pool release];
	if (error != nil) {
		[*error autorelease];
	}
	return [objects autorelease];
}

- (void) setFetchLimit:(NSUInteger)newLimit {
	if (newLimit > SKPageSizeLimitMax) {
		newLimit = SKPageSizeLimitMax;
	}
	fetchLimit = newLimit;
}

@end
