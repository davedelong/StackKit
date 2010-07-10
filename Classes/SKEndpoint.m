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
@synthesize path, error, query, request, didValidateSortDescriptor, didValidatePredicate, didValidateRanges;

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
	 2.  Validate the sort
	 3.  Validate the predicate
	 4.  Extract ranges from predicate
	 **/
	
	if (![self validateEntity:[[self request] entity]]) {
		return NO;
	}
	
	NSSortDescriptor * cleanedSortDescriptor = [self cleanSortDescriptor:[[self request] sortDescriptor]];
	didValidateSortDescriptor = [self validateSortDescriptor:cleanedSortDescriptor];
	if ([self didValidateSortDescriptor] == NO) { return NO; }
	
	NSPredicate * cleanedPredicate = [self cleanPredicate:[[self request] predicate]];
	didValidatePredicate = [self validatePredicate:cleanedPredicate];
	if ([self didValidatePredicate] == NO) { return NO; }
	
	didValidateRanges = [self validateRangesInPredicate:cleanedPredicate];
	if ([self didValidateRanges] == NO) { return NO; }
	
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
	NSDictionary * validSortKeys = [self validSortDescriptorKeys];
	
	if (validSortKeys == nil && sortDescriptor == nil) {
		//this endpoint doesn't support sorting, and we weren't given a sort descriptor
		return YES;
	}
	
	if (validSortKeys == nil && sortDescriptor != nil) {
		//trying to specify a sort descriptor on a endpoint that doesn't support it
		[self setError:[NSError errorWithDomain:SKErrorDomain code:SKErrorCodeInvalidSort userInfo:nil]];
		return NO;
	}
	
	if (validSortKeys != nil && sortDescriptor == nil) {
		//ok, since we're going to go with the default, implicit sort
	}
	
	if (validSortKeys != nil && sortDescriptor != nil) { 
		//need to validate the sort descriptor
		NSString * sortKey = [sortDescriptor key];
		if (sortKey == nil) {
			[self setError:[NSError errorWithDomain:SKErrorDomain code:SKErrorCodeInvalidSort userInfo:nil]];
			return NO;
		}
		
		NSString * requestSort = [validSortKeys objectForKey:sortKey];
		if (requestSort == nil) {
			//it could be that the key is already cleaned:
			if ([[validSortKeys allValues] containsObject:sortKey] == NO) {
				//this sorting key isn't valid
				[self setError:[NSError errorWithDomain:SKErrorDomain code:SKErrorCodeInvalidSort userInfo:nil]];
				return NO;
			} else {
				requestSort = sortKey;
			}
		}
		
		//check to make sure we're not using a block for comparison
		//use respondsTo... and perform... so that this will still work on 10.5
		if ([sortDescriptor respondsToSelector:@selector(comparator)]) {
			id comparator = [sortDescriptor performSelector:@selector(comparator)];
			if (comparator != nil) {
				NSString * msg = @"Sort descriptors may not use comparator blocks";
				[self setError:[NSError errorWithDomain:SKErrorDomain code:SKErrorCodeInvalidSort userInfo:[NSDictionary dictionaryWithObject:msg forKey:NSLocalizedDescriptionKey]]];
				return NO;
			}
		}
		
		//check to make sure that we're not using any special comparison selector
		SEL comparisonSelector = [sortDescriptor selector];
		if (comparisonSelector == nil || sel_isEqual(comparisonSelector, @selector(compare:)) == NO) {
			NSString * msg = @"Sort descriptors may only sort using the compare: selector";
			[self setError:[NSError errorWithDomain:SKErrorDomain code:SKErrorCodeInvalidSort userInfo:[NSDictionary dictionaryWithObject:msg forKey:NSLocalizedDescriptionKey]]];
			return NO;
		}
		
		//if we get here the key is valid and the comparison is valid
		[[self query] setObject:requestSort forKey:SKQuerySort];
		[[self query] setObject:([sortDescriptor ascending] ? @"asc" : @"desc") forKey:SKQuerySortOrder];
	}
	
	return YES;
}

- (BOOL) validateRangesInPredicate:(NSPredicate *)predicate {
	if (predicate == nil) { return YES; }
	if ([predicate isSimpleAndPredicate] == NO) {
		//return YES if it's a comparison, else NO (more complex than simple AND)
		if ([predicate isKindOfClass:[NSComparisonPredicate class]] == NO) {
			[self setError:[NSError errorWithDomain:SKErrorDomain code:SKErrorCodeInvalidPredicate userInfo:nil]];
			return NO;
		}
		return YES;
	}
	
	//it's a simple AND
	NSDictionary * validRangeKeys = [self validRangeKeys];
	NSString * sortKey = [self sortDescriptorKey];
	if (sortKey == nil) {
		return YES;
	}
	NSString * rangeKeyPath = [validRangeKeys objectForKey:[self sortDescriptorKey]];
	if (rangeKeyPath == nil) {
		//we have a valid sort key but an invalid range key?  shouldn't happen...
		[self setError:[NSError errorWithDomain:SKErrorDomain code:SKErrorCodeInvalidSort userInfo:[NSDictionary dictionaryWithObject:@"valid sort but invalid range" forKey:NSLocalizedDescriptionKey]]];
		return NO;
	}
	
	NSString * minKey = ([sortKey isEqual:SKSortCreation] ? SKQueryFromDate : SKQueryMinSort);
	NSString * maxKey = ([sortKey isEqual:SKSortCreation] ? SKQueryToDate : SKQueryMaxSort);
	
	SKRange range = [predicate rangeOfConstantValuesForLeftKeyPath:rangeKeyPath];
	if (range.lower != SKNotFound) {
		[[self query] setObject:[NSNumber numberWithUnsignedInteger:range.lower] forKey:minKey];
	}
	if (range.upper != SKNotFound) {
		[[self query] setObject:[NSNumber numberWithUnsignedInteger:range.upper] forKey:maxKey];
	}
	
	return YES;
}

- (NSString *) sortDescriptorKey {
	return [[self query] objectForKey:SKQuerySort];
}

- (NSDictionary *) validPredicateKeyPaths {
	return nil;
}

- (NSDictionary *) validSortDescriptorKeys {
	return nil;
}

- (NSDictionary *) validRangeKeys {
	return nil;
}

- (NSSortDescriptor *) cleanSortDescriptor:(NSSortDescriptor *)sortDescriptor {
	NSDictionary * sortDescriptorKeys = [self validSortDescriptorKeys];
	NSString * key = [sortDescriptor key];
	NSString * cleanedKey = [sortDescriptorKeys objectForKey:key];
	if (cleanedKey != nil) {
		return [[[NSSortDescriptor alloc] initWithKey:cleanedKey ascending:[sortDescriptor ascending] selector:[sortDescriptor selector]] autorelease];
	}
	//this can't be cleaned
	//return the same descriptor, because the validate method will choke on it
	return sortDescriptor;
}

- (NSPredicate *) cleanPredicate:(NSPredicate *)predicate {
	NSDictionary * predicateKeyPaths = [self validPredicateKeyPaths];
	return [predicate predicateByReplacingLeftKeyPathsFromMapping:predicateKeyPaths];
}

- (NSURL *) APIURLForFetchRequest:(SKFetchRequest *)fetchRequest {
	if ([self error] != nil) { return nil; }
	
	if ([fetchRequest fetchLimit] > 0) {
		[[self query] setObject:[NSNumber numberWithUnsignedInteger:[fetchRequest fetchLimit]] forKey:SKQueryPageSize];
		NSUInteger page = ([fetchRequest fetchOffset] / [fetchRequest fetchLimit]) + 1;
		[[self query] setObject:[NSNumber numberWithUnsignedInteger:page] forKey:SKQueryPage];
	}
	
	NSString * urlBase = [[[[self request] site] apiURL] absoluteString];
	NSString * apiPath = [NSString stringWithFormat:@"%@?%@", [self path], [[self query] queryString]];
	
	NSString * fullAPIString = [urlBase stringByAppendingString:apiPath];
	
	return [NSURL URLWithString:fullAPIString];
}

@end
