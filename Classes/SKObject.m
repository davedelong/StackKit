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

+ (NSURL *) constructAPICallForBaseURL:(NSURL *)base relativePath:(NSString *)path query:(NSDictionary *)query {
	NSString * queryString = [query queryString];
	if (queryString != nil) {
		path = [NSString stringWithFormat:@"%@?%@", path, queryString];
	}
	NSURL * relativeURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", base, path]];
	
	return [relativeURL absoluteURL];
}

+ (NSURL *) apiCallForFetchRequest:(SKFetchRequest *)request error:(NSError **)error {
	if (error != nil) {
		*error = [NSError errorWithDomain:SKErrorDomain code:SKErrorCodeNotImplemented userInfo:nil];
	}
	
	NSAssert(NO, ([NSString stringWithFormat:@"-[%@ %@] must be overridden", NSStringFromClass([self class]), NSStringFromSelector(_cmd)]));
	return nil;
}

+ (id) objectWithSite:(SKSite *)aSite dictionaryRepresentation:(NSDictionary *)dictionary {
	return [[[self alloc] initWithSite:aSite dictionaryRepresentation:dictionary] autorelease];
}

- (id) initWithSite:(SKSite *)aSite dictionaryRepresentation:(NSDictionary *)dictionary {
	NSAssert(NO, ([NSString stringWithFormat:@"-[%@ %@] must be overridden", NSStringFromClass([self class]), NSStringFromSelector(_cmd)]));
	return nil;
}

+ (NSDictionary *) APIAttributeToPropertyMapping {
	NSAssert(NO, ([NSString stringWithFormat:@"-[%@ %@] must be overridden", NSStringFromClass([self class]), NSStringFromSelector(_cmd)]));
	return nil;
}

+ (NSString *) keyForKey:(NSString *)key {
	NSDictionary * mappings = [self APIAttributeToPropertyMapping];
	if ([mappings objectForKey:key] != nil) {
		return [mappings objectForKey:key];
	}
	return key;
}

#pragma mark KVC Compliance

- (id) valueForUndefinedKey:(NSString *)key {
	NSString * newKey = [[self class] keyForKey:key];
	if (newKey != nil) {
		return [self valueForKey:newKey];
	}
	return [super valueForUndefinedKey:key];
}

@end
