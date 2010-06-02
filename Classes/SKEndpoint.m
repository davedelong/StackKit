//
//  SKEndpoint.m
//  StackKit
//
//  Created by Dave DeLong on 6/2/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "StackKit_Internal.h"

@implementation SKEndpoint
@synthesize path, error, query;

+ (id) endpoint {
	return [[[self alloc] init] autorelease];
}

- (id) init {
	if (self = [super init]) {
		query = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (void) dealloc {
	[query release];
	[path release];
	[error release];
	[super dealloc];
}

- (BOOL) validateFetchRequest:(SKFetchRequest *)request {
	[query addEntriesFromDictionary:[request defaultQueryDictionary]];
	/**
	 Validation steps:
	 
	 1.  Validate the entity
	 2.  Validate the predicate
	 3.  Validate the sort
	 **/
	
	if (![self validateEntity:[request entity]]) {
		return NO;
	}
	
	if (![self validatePredicate:[request predicate]]) {
		return NO;
	}
	
	if (![self validateSortDescriptor:[request sortDescriptor]]) {
		return NO;
	}
	
	return YES;
}

- (BOOL) validateEntity:(Class)entity {
	if ([self error] != nil) { return NO; }
	[self setError:[NSError errorWithDomain:SKErrorDomain code:SKErrorCodeNotImplemented userInfo:nil]];
	return NO;
}

- (BOOL) validatePredicate:(NSPredicate *)predicate {
	if ([self error] != nil) { return NO; }
	[self setError:[NSError errorWithDomain:SKErrorDomain code:SKErrorCodeNotImplemented userInfo:nil]];
	return NO;
}

- (BOOL) validateSortDescriptor:(NSSortDescriptor *)sortDescriptor {
	if ([self error] != nil) { return NO; }
	[self setError:[NSError errorWithDomain:SKErrorDomain code:SKErrorCodeNotImplemented userInfo:nil]];
	return NO;
}

- (NSString *) apiPath {
	if ([self error] != nil) { return nil; }
	
	return [NSString stringWithFormat:@"%@?%@", [self path], [[self query] queryString]];
}

- (NSURL *) APIURLForFetchRequest:(SKFetchRequest *)request {
	if ([self error] != nil) { return nil; }
	
	NSString * urlBase = [[[request site] APIURL] absoluteString];
	NSString * apiPath = [self apiPath];
	
	NSString * fullAPIString = [urlBase stringByAppendingString:apiPath];
	return [NSURL URLWithString:fullAPIString];
}

@end
