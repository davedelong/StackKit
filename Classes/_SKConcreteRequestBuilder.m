//
//  _SKConcreteRequestBuilder.m
//  StackKit
/**
  Copyright (c) 2011 Dave DeLong
 
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

#import "_SKConcreteRequestBuilder.h"
#import "SKSite+Private.h"
#import "NSDictionary+SKAdditions.h"

@interface _SKConcreteRequestBuilder ()

@property (nonatomic, retain) NSURL * URL;

@end


@implementation _SKConcreteRequestBuilder
@synthesize fetchRequest;
@synthesize error;
@synthesize URL;
@synthesize query;
@synthesize path;

- (id) initWithFetchRequest:(SKFetchRequest *)request {
	self = [super init];
	if (self) {
		fetchRequest = [request retain];
		query = [[NSMutableDictionary alloc] init];
		
		[query setObject:[[request site] apiKey] forKey:SKSiteAPIKey];
		
		if ([request fetchLimit] > 0) {
			[query setObject:[NSNumber numberWithUnsignedInteger:[request fetchLimit]] forKey:SKQueryPageSize];
			NSUInteger page = ([request fetchOffset] / [request fetchLimit]) + 1;
			[query setObject:[NSNumber numberWithUnsignedInteger:page] forKey:SKQueryPage];
		}
		
		if ([request sortDescriptor] != nil) {
			NSString * sortKey = [[request sortDescriptor] key];
			NSDictionary * recognizedSortKeys = [[self class] recognizedSortDescriptorKeys];
			if ([recognizedSortKeys objectForKey:sortKey] != nil) {
				sortKey = [recognizedSortKeys objectForKey:sortKey];
			}
			[query setObject:sortKey forKey:SKQuerySort];
			[query setObject:([[request sortDescriptor] ascending] ? @"asc" : @"desc") forKey:SKQuerySortOrder];
		}
		
		[self buildURL];
	}
	return self;
}

- (void) dealloc {
	[fetchRequest release];
	[error release];
	[URL release];
	[query release];
	[path release];
	[super dealloc];
}

+ (Class) recognizedFetchEntity { return nil; }
+ (BOOL) recognizesAPredicate { return YES; }
+ (NSDictionary *) recognizedPredicateKeyPaths { return [NSDictionary dictionary]; }
+ (NSSet *) requiredPredicateKeyPaths { return [NSSet set]; }
+ (BOOL) recognizesASortDescriptor { return YES; }

+ (NSSet *) allRecognizedSortDescriptorKeys {
	NSDictionary * sortKeys = [self recognizedSortDescriptorKeys];
	NSMutableSet * all = [NSMutableSet setWithArray:[sortKeys allKeys]];
	[all addObjectsFromArray:[sortKeys allValues]];
	return all;
}
+ (NSDictionary *) recognizedSortDescriptorKeys { return [NSDictionary dictionary]; }

- (void) buildURL {
	//don't rebuild if we've already been built
	if ([self error] != nil || [self URL] != nil) { return; }
	
	if ([self isMemberOfClass:[_SKConcreteRequestBuilder class]]) {
		[self setError:[NSError errorWithDomain:SKErrorDomain 
										   code:SKErrorCodeNotImplemented 
									   userInfo:SK_EREASON(@"cannot allocate %@", NSStringFromClass([self class]))]];
		return;
	}
	
	NSURL * apiURL = [[fetchRequest site] apiURL];
	NSString * urlBase = [apiURL absoluteString];
	NSString * apiPath = [NSString stringWithFormat:@"%@?%@", 
						  ([self path] ? [self path] : @""), 
						  [query sk_queryString]];
	
	NSString * fullAPIString = [urlBase stringByAppendingString:apiPath];
	
	[self setURL:[NSURL URLWithString:fullAPIString]];
}

- (NSPredicate *) requestPredicate {
	return [[self fetchRequest] predicate];
}

- (NSSortDescriptor *) requestSortDescriptor {
	return [[self fetchRequest] sortDescriptor];
}

@end
