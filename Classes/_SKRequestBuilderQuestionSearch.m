//
//  _SKRequestBuilderQuestionSearch.m
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

#import "_SKRequestBuilderQuestionSearch.h"


@implementation _SKRequestBuilderQuestionSearch

+ (Class) recognizedFetchEntity {
	return [SKQuestion class];
}

+ (NSDictionary *) recognizedPredicateKeyPaths {
	return [NSDictionary dictionaryWithObjectsAndKeys:
			SK_BOX(NSContainsPredicateOperatorType), SKQuestionTitle,
			SK_BOX(NSContainsPredicateOperatorType), SKQuestionTags,
			SK_BOX(NSGreaterThanOrEqualToPredicateOperatorType, NSLessThanOrEqualToPredicateOperatorType), SKQuestionLastActivityDate,
			SK_BOX(NSGreaterThanOrEqualToPredicateOperatorType, NSLessThanOrEqualToPredicateOperatorType), SKQuestionViewCount,
			SK_BOX(NSGreaterThanOrEqualToPredicateOperatorType, NSLessThanOrEqualToPredicateOperatorType), SKQuestionCreationDate,
			SK_BOX(NSGreaterThanOrEqualToPredicateOperatorType, NSLessThanOrEqualToPredicateOperatorType), SKQuestionScore,
			nil];
}

+ (NSDictionary *) recognizedSortDescriptorKeys {
	return [NSDictionary dictionaryWithObjectsAndKeys:
			SKSortActivity, SKQuestionLastActivityDate,
			SKSortViews, SKQuestionViewCount,
			SKSortCreation, SKQuestionCreationDate,
			SKSortVotes, SKQuestionScore,
			nil];
}

- (void) buildURL {
	NSPredicate * p = [self requestPredicate];
	
	id inTitle = [p constantValueForLeftKeyPath:SKQuestionTitle];
	id tagged = [p constantValueForLeftKeyPath:SKQuestionTags];
	
	if (inTitle == nil && tagged == nil) {
		[self setError:SK_PREDERROR(@"Searching requires a title or tag predicate")];
		return;
	}
	
	if (inTitle != nil) {
		[[self query] setObject:inTitle forKey:SKQueryInTitle];
	}
	
	if (tagged != nil) {
		[[self query] setObject:SKExtractTagName(tagged) forKey:SKQueryTagged];
	}
	
	//TODO: nottagged?
	
	[[self query] setObject:SKQueryTrue forKey:SKQueryBody];
	
	[self setPath:@"/search"];
	
	if ([self requestSortDescriptor] != nil) {
		SKRange sortRange = [p rangeOfConstantValuesForLeftKeyPath:[[self requestSortDescriptor] key]];
		if (sortRange.lower != SKNotFound) {
			[[self query] setObject:sortRange.lower forKey:SKQueryMinSort];
		}
		if (sortRange.upper != SKNotFound) {
			[[self query] setObject:sortRange.upper forKey:SKQueryMaxSort];
		}
	}
	
	[super buildURL];
}

@end
