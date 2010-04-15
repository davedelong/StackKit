//
//  SKObject.m
//  StackKit
//
//  Created by Dave DeLong on 1/25/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "StackKit_Internal.h"

@implementation SKObject
@synthesize site;

#pragma mark -
#pragma mark Init/Dealloc

- (id) initWithSite:(SKSite *)aSite {
	if (self = [super init]) {
		site = aSite;
	}
	return self;
}

- (void) setSite:(SKSite *)newSite {
	if (newSite != site) {
		site = newSite;
	}
}

#pragma mark -
#pragma mark Fetch Requests

+ (id) objectWithSite:(SKSite *)aSite dictionaryRepresentation:(NSDictionary *)dictionary {
	return [[[self alloc] initWithSite:aSite dictionaryRepresentation:dictionary] autorelease];
}

- (id) initWithSite:(SKSite *)aSite dictionaryRepresentation:(NSDictionary *)dictionary {
	NSAssert(NO, ([NSString stringWithFormat:@"-[%@ %@] must be overridden", NSStringFromClass([self class]), NSStringFromSelector(_cmd)]));
	return nil;
}

+ (NSURL *) apiCallForFetchRequest:(SKFetchRequest *)request error:(NSError **)error {
	if (error != nil) {
		*error = [NSError errorWithDomain:SKErrorDomain code:SKErrorCodeNotImplemented userInfo:nil];
	}
	
	NSAssert(NO, ([NSString stringWithFormat:@"-[%@ %@] must be overridden", NSStringFromClass([self class]), NSStringFromSelector(_cmd)]));
	return nil;
}

+ (NSURL *) constructAPICallForBaseURL:(NSURL *)base relativePath:(NSString *)path query:(NSDictionary *)query {
	NSString * queryString = [query queryString];
	if (queryString != nil) {
		path = [NSString stringWithFormat:@"%@?%@", path, queryString];
	}
	NSURL * relativeURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", base, path]];
	
	return [relativeURL absoluteURL];
}

+ (NSDictionary *) APIAttributeToPropertyMapping {
	NSAssert(NO, ([NSString stringWithFormat:@"-[%@ %@] must be overridden", NSStringFromClass([self class]), NSStringFromSelector(_cmd)]));
	return nil;
}

+ (NSString *) propertyKeyFromAPIAttributeKey:(NSString *)key {
	NSDictionary * mappings = [self APIAttributeToPropertyMapping];
	if ([mappings objectForKey:key] != nil) {
		return [mappings objectForKey:key];
	}
	return key;
}

+ (NSPredicate *) updatedPredicateForFetchRequest:(SKFetchRequest *)request {
	return [request predicate];
}

+ (NSArray *) updatedSortDescriptorsForFetchRequest:(SKFetchRequest *)request {
	return [request sortDescriptors];
}

#pragma mark -
#pragma mark KVC Compliance

- (id) valueForUndefinedKey:(NSString *)key {
	NSString * newKey = [[self class] propertyKeyFromAPIAttributeKey:key];
	if (newKey != nil) {
		return [self valueForKey:newKey];
	}
	return [super valueForKey:key];
}

@end
