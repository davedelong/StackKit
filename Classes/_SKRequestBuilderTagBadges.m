//
//  _SKRequestBuilderTagBadges.m
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

#import "_SKRequestBuilderTagBadges.h"
#import "SKBadge.h"

@implementation _SKRequestBuilderTagBadges

+ (Class) recognizedFetchEntity {
	return [SKBadge class];
}

+ (NSDictionary *) recognizedPredicateKeyPaths {
	return [NSDictionary dictionaryWithObjectsAndKeys:
			SK_BOX(NSEqualToPredicateOperatorType), SKBadgeTagBased,
			nil];
}

+ (NSSet *) requiredPredicateKeyPaths {
	return [NSSet setWithObjects:
			SKBadgeTagBased,
			nil];
}

+ (NSDictionary *) recognizedSortDescriptorKeys {
	return [NSDictionary dictionaryWithObjectsAndKeys:
			SKSortName, SKBadgeName,
			nil];
}

- (void) buildURL {
	if ([self requestSortDescriptor] != nil && [[self requestSortDescriptor] ascending] == NO) {
		[self setError:SK_SORTERROR(@"badges can only be requested in ascending order")];
	}
	
	id tagBased = [[self requestPredicate] constantValueForLeftKeyPath:SKBadgeTagBased];
	if ([tagBased isKindOfClass:[NSNumber class]] == NO || [tagBased boolValue] == NO) {
		[self setError:SK_PREDERROR(@"Invalid predicate for fetching tag badges")];
	}
	
	[self setPath:@"/badges/tags"];
	[super buildURL];
}

@end
