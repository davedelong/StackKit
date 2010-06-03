//
//  SKEndpoint.m
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

@implementation SKEndpoint
@synthesize path, error, query, request;

+ (id) endpointForFetchRequest:(SKFetchRequest *)request {
	return [[[self alloc] initWithFetchRequest:request] autorelease];
}

- (id) initWithFetchRequest:(SKFetchRequest *)aRequest {
	if (self = [super init]) {
		[self setRequest:aRequest];
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

- (BOOL) validateFetchRequest {
	[query addEntriesFromDictionary:[[self request] defaultQueryDictionary]];
	/**
	 Validation steps:
	 
	 1.  Validate the entity
	 2.  Validate the predicate
	 3.  Validate the sort
	 **/
	
	if (![self validateEntity:[[self request] entity]]) {
		return NO;
	}
	
	if (![self validatePredicate:[[self request] predicate]]) {
		return NO;
	}
	
	if (![self validateSortDescriptor:[[self request] sortDescriptor]]) {
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
	
	//use respondsTo... and perform... so that this will still work on 10.5
	if ([sortDescriptor respondsToSelector:@selector(comparator)]) {
		id comparator = [sortDescriptor performSelector:@selector(comparator)];
		if (comparator != nil) {
			NSString * msg = @"Sort descriptors may not use comparator blocks";
			[self setError:[NSError errorWithDomain:SKErrorDomain code:SKErrorCodeInvalidSort userInfo:[NSDictionary dictionaryWithObject:msg forKey:NSLocalizedDescriptionKey]]];
			return NO;
		}
	}
	
	SEL comparisonSelector = [sortDescriptor selector];
	if (comparisonSelector == nil || sel_isEqual(comparisonSelector, @selector(compare:)) == NO) {
		NSString * msg = @"Sort descriptors may only sort using the compare: selector";
		[self setError:[NSError errorWithDomain:SKErrorDomain code:SKErrorCodeInvalidSort userInfo:[NSDictionary dictionaryWithObject:msg forKey:NSLocalizedDescriptionKey]]];
		return NO;
	}
	
	return YES;
}

- (NSString *) apiPath {
	if ([self error] != nil) { return nil; }
	
	return [NSString stringWithFormat:@"%@?%@", [self path], [[self query] queryString]];
}

- (NSURL *) APIURLForFetchRequest:(SKFetchRequest *)request {
	if ([self error] != nil) { return nil; }
	
	NSString * urlBase = [[[[self request] site] APIURL] absoluteString];
	NSString * apiPath = [self apiPath];
	
	NSString * fullAPIString = [urlBase stringByAppendingString:apiPath];
	return [NSURL URLWithString:fullAPIString];
}

@end
