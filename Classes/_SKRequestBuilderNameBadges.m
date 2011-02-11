//
//  _SKRequestBuilderNameBadges.m
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

#import "_SKRequestBuilderNameBadges.h"
#import "SKBadge.h"

@implementation _SKRequestBuilderNameBadges

+ (Class) recognizedFetchEntity {
	return [SKBadge class];
}

+ (NSDictionary *) recognizedPredicateKeyPaths {
	return [NSDictionary dictionaryWithObjectsAndKeys:
			SK_BOX(NSEqualToPredicateOperatorType), @"tagBased",
			nil];
}

+ (NSSet *) requiredPredicateKeyPaths {
	return [NSSet setWithObjects:
			@"tagBased",
			nil];
}

+ (NSDictionary *) recognizedSortDescriptorKeys {
	return [NSDictionary dictionaryWithObjectsAndKeys:
			SKSortName, @"name",
			nil];
}

- (void) buildURL {
	if ([self requestSortDescriptor] != nil && [[self requestSortDescriptor] ascending] == NO) {
		[self setError:SK_SORTERROR(@"badges can only be requested in ascending order")];
	}
	
	id tagBased = [[self requestPredicate] constantValueForLeftKeyPath:@"tagBased"];
	if ([tagBased isKindOfClass:[NSNumber class]] == NO || [tagBased boolValue] == YES) {
		[self setError:SK_PREDERROR(@"Invalid predicate for fetching named badges")];
	}
	
	[self setPath:@"/badges/name"];
	[super buildURL];
}

@end
