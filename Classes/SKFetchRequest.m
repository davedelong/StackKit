//
//  SKFetchRequest.m
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
#import <objc/runtime.h>

@implementation SKFetchRequest
@synthesize entity;
@synthesize sortDescriptor;
@synthesize fetchLimit;
@synthesize fetchOffset;
@synthesize predicate;
@synthesize error;
@synthesize delegate;
@synthesize fetchURL;

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
	[sortDescriptor release];
	[predicate release];
	[error release];
	[fetchURL release];
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

- (NSMutableDictionary *) defaultQueryDictionary {
	NSMutableDictionary * d = [NSMutableDictionary dictionary];
	[d setObject:[[self site] APIKey] forKey:SKSiteAPIKey];
	
	return d;
}

- (NSPredicate *) cleanedPredicate {
	NSDictionary * keyPathMapping = [[self entity] validPredicateKeyPaths];
	if (keyPathMapping == nil) { return [self predicate]; }
	return [[self predicate] predicateByReplacingLeftKeyPathsFromMapping:keyPathMapping];
}

- (NSSortDescriptor *) cleanedSortDescriptor {
	//evaluate the sort descriptors.  error if there are non-supported keys, comparators, or selectors, and replace keys as appropriate
	NSDictionary * validSortKeys = [[self entity] validSortDescriptorKeys];
	
	NSSortDescriptor * sort = [self sortDescriptor];
	NSString * sortKey = [sort key];
	NSString * cleanedKey = [validSortKeys objectForKey:sortKey];
	if (cleanedKey == nil) {
		NSString * msg = [NSString stringWithFormat:@"%@ is not a valid sort key", sortKey];
		[self setError:[NSError errorWithDomain:SKErrorDomain code:SKErrorCodeInvalidSort userInfo:[NSDictionary dictionaryWithObject:msg forKey:NSLocalizedDescriptionKey]]];
		return nil;
	}
	
	//use respondsTo... and perform... so that this will still work on 10.5
	if ([sort respondsToSelector:@selector(comparator)]) {
		id comparator = [sort performSelector:@selector(comparator)];
		if (comparator != nil) {
			NSString * msg = @"Sort descriptors may not use comparator blocks";
			[self setError:[NSError errorWithDomain:SKErrorDomain code:SKErrorCodeInvalidSort userInfo:[NSDictionary dictionaryWithObject:msg forKey:NSLocalizedDescriptionKey]]];
			return nil;
		}
	}
	
	SEL comparisonSelector = [sort selector];
	if (comparisonSelector == nil || sel_isEqual(comparisonSelector, @selector(compare:)) == NO) {
		NSString * msg = @"Sort descriptors may only sort using the compare: selector";
		[self setError:[NSError errorWithDomain:SKErrorDomain code:SKErrorCodeInvalidSort userInfo:[NSDictionary dictionaryWithObject:msg forKey:NSLocalizedDescriptionKey]]];
		return nil;
	}
	
	NSSortDescriptor * newDescriptor = [[NSSortDescriptor alloc] initWithKey:cleanedKey ascending:[sort ascending] selector:[sort selector]];
	return [newDescriptor autorelease];
}

- (NSURL *) apiCall {
	if ([self site] == nil) { return nil; }
	
	Class fetchEntity = [self entity];
	
	if ([fetchEntity respondsToSelector:@selector(endpoints)] == NO) {
		[self setError:[NSError errorWithDomain:SKErrorDomain code:SKErrorCodeInvalidEntity userInfo:nil]];
		return nil;
	}
	
	NSArray * endpoints = [fetchEntity endpoints];
	for (Class endpointClass in endpoints) {
		SKEndpoint * endpoint = [endpointClass endpoint];
		if ([endpoint validateFetchRequest:self]) {
			[self setError:nil];
			return [endpoint APIURLForFetchRequest:self];
		} else {
			[self setError:[endpoint error]];
		}
	}
	
	return nil;
}

- (void) executeAsynchronously {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	NSArray * results = [self execute];
	
	if ([self error] != nil) {
		//ERROR!
		if ([self delegate] && [[self delegate] respondsToSelector:@selector(fetchRequest:didFailWithError:)]) {
			[[self delegate] fetchRequest:self didFailWithError:[self error]];
		}
	} else {
		//OK
		if ([self delegate] && [[self delegate] respondsToSelector:@selector(fetchRequest:didReturnResults:)]) {
			[[self delegate] fetchRequest:self didReturnResults:results];
		}
	}
	
	[pool release];
}

- (NSArray *) execute {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	NSString * apiKey = [[self site] APIKey];
	if (apiKey == nil) {
		[self setError:[NSError errorWithDomain:SKErrorDomain code:SKErrorCodeInvalidApplicationPublicKey userInfo:nil]];
		goto cleanup;
	}
	
	//construct our fetch url
	[self setFetchURL:[self apiCall]];
	
	if ([self error] != nil) { goto cleanup; }
	if ([self fetchURL] == nil) { goto cleanup; }
	
	NSArray * objects = [[self executeFetchRequest] retain];
	
cleanup:
	[pool release];
	return [objects autorelease];
}

- (NSArray *) executeFetchRequest {
	SKLog(@"fetching from: %@", fetchURL);
	
	//signal the delegate
	if ([self delegate] && [[self delegate] respondsToSelector:@selector(fetchRequestWillBeginExecuting:)]) {
		[[self delegate] fetchRequestWillBeginExecuting:self];
	}
	
	//execute the GET request
	NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[self fetchURL]];
	NSURLResponse * response = nil;
	NSError * connectionError = nil;
	NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&connectionError];
	
	//signal the delegate
	if ([self delegate] && [[self delegate] respondsToSelector:@selector(fetchRequestDidFinishExecuting:)]) {
		[[self delegate] fetchRequestDidFinishExecuting:self];
	}
	
	if (connectionError != nil) {
		[self setError:connectionError];
		return nil;
	}
	
	//handle the response
	NSString * responseString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
	
	NSDictionary * responseObjects = [responseString JSONValue];
	if ([responseObjects isKindOfClass:[NSDictionary class]] == NO) {
		[self setError:[NSError errorWithDomain:SKErrorDomain code:SKErrorCodeUnknownError userInfo:nil]];
		return nil;
	}
	
	//check for an error in the response
	NSDictionary * errorDictionary = [responseObjects objectForKey:SKErrorResponseKey];
	if (errorDictionary != nil) {
		//there was an error responding to the request
		NSNumber * errorCode = [errorDictionary objectForKey:SKErrorCodeKey];
		NSString * errorMessage = [errorDictionary objectForKey:SKErrorMessageKey];
		
		NSDictionary * userInfo = [NSDictionary dictionaryWithObject:errorMessage forKey:NSLocalizedDescriptionKey];
		[self setError:[NSError errorWithDomain:SKErrorDomain code:[errorCode integerValue] userInfo:userInfo]];
		return nil;
	}
	
	//pull out the data container
	NSString * dataKey = [[self entity] dataKey];
	id dataObject = [responseObjects objectForKey:dataKey];
	
	NSMutableArray * objects = [[NSMutableArray alloc] init];	
	
	//parse the response into objects
	if ([dataObject isKindOfClass:[NSArray class]]) {
		for (NSDictionary * dataDictionary in dataObject) {
			SKObject * object = [[self entity] objectWithSite:[self site] dictionaryRepresentation:dataDictionary];
			[objects addObject:object];
		}
	} else if ([dataObject isKindOfClass:[NSDictionary class]]) {
		SKObject * object = [[self entity] objectWithSite:[self site] dictionaryRepresentation:dataObject];
		[objects addObject:object];
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
