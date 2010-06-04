//
//  SKObject.m
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

+ (NSURL *) apiCallForFetchRequest:(SKFetchRequest *)request {
	[request setError:[NSError errorWithDomain:SKErrorDomain code:SKErrorCodeNotImplemented userInfo:nil]];
	
	NSAssert(NO, ([NSString stringWithFormat:@"+[%@ %@] must be overridden", NSStringFromClass(self), NSStringFromSelector(_cmd)]));
	return nil;
}

+ (NSURL *) constructAPICallForBaseURL:(NSURL *)base relativePath:(NSString *)path query:(NSDictionary *)query {
	NSString * queryString = [query queryString];
	if (queryString != nil) {
		path = [NSString stringWithFormat:@"%@?%@", path, queryString];
	}
	NSURL * relativeURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [base absoluteString], path]];

	return [relativeURL absoluteURL];
}

+ (NSDictionary *) APIAttributeToPropertyMapping {
	NSAssert(NO, ([NSString stringWithFormat:@"+[%@ %@] must be overridden", NSStringFromClass(self), NSStringFromSelector(_cmd)]));
	return nil;
}

+ (NSString *) dataKey {
	NSAssert(NO, ([NSString stringWithFormat:@"+[%@ %@] must be overridden", NSStringFromClass(self), NSStringFromSelector(_cmd)]));
	return nil;
}

+ (NSString *) propertyKeyFromAPIAttributeKey:(NSString *)key {
	NSDictionary * mappings = [self APIAttributeToPropertyMapping];
	if ([mappings objectForKey:key] != nil) {
		return [mappings objectForKey:key];
	}
	return key;
}

+ (NSArray *) endpoints {
	return [NSArray arrayWithObject:[SKEndpoint class]];
}

#pragma mark -
#pragma mark KVC Compliance

- (id) valueForUndefinedKey:(NSString *)key {
	NSString * newKey = [[self class] propertyKeyFromAPIAttributeKey:key];
	if (newKey != nil && [newKey isEqual:key] == NO) {
		return [self valueForKey:newKey];
	}
	return [super valueForKey:key];
}

@end
