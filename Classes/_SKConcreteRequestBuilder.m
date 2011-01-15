//
//  _SKConcreteRequestBuilder.m
//  StackKit
//
//  Created by Dave DeLong on 1/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "_SKConcreteRequestBuilder.h"

@interface _SKConcreteRequestBuilder ()

@property (nonatomic, retain) NSError * error;
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
		[query setObject:SKQueryTrue forKey:SKQueryBody];
		
		if ([request fetchLimit] > 0) {
			[query setObject:[NSNumber numberWithUnsignedInteger:[request fetchLimit]] forKey:SKQueryPageSize];
			NSUInteger page = ([request fetchOffset] / [request fetchLimit]) + 1;
			[query setObject:[NSNumber numberWithUnsignedInteger:page] forKey:SKQueryPage];
		}
		
		if ([request sortDescriptor] != nil) {
			[query setObject:[[request sortDescriptor] key] forKey:SKQuerySort];
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
+ (NSSet *) recognizedSortDescriptorKeys { return [NSSet set]; }

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
						  [query queryString]];
	
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
