//
//  _SKRequestBuilderQuestionSearch.m
//  StackKit
//
//  Created by Dave DeLong on 1/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

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

+ (NSSet *) recognizedSortDescriptorKeys {
	return [NSSet setWithObjects:
			SKQuestionLastActivityDate,
			SKQuestionViewCount,
			SKQuestionCreationDate,
			SKQuestionScore,
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
			[[self query] setObject:[NSNumber numberWithUnsignedInteger:sortRange.lower] forKey:SKQueryMinSort];
		}
		if (sortRange.upper != SKNotFound) {
			[[self query] setObject:[NSNumber numberWithUnsignedInteger:sortRange.upper] forKey:SKQueryMaxSort];
		}
	}
	
	[super buildURL];
}

@end
