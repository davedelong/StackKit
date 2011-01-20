//
//  _SKRequestBuilderUnansweredQuestions.m
//  StackKit
//
//  Created by Dave DeLong on 1/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "_SKRequestBuilderUnansweredQuestions.h"


@implementation _SKRequestBuilderUnansweredQuestions

+ (Class) recognizedFetchEntity {
	return [SKQuestion class];
}

+ (NSDictionary *) recognizedPredicateKeyPaths {
	return [NSDictionary dictionaryWithObjectsAndKeys:
			SK_BOX(NSGreaterThanOrEqualToPredicateOperatorType, NSLessThanOrEqualToPredicateOperatorType, NSEqualToPredicateOperatorType), SKQuestionAnswerCount,
			SK_BOX(NSGreaterThanOrEqualToPredicateOperatorType, NSLessThanOrEqualToPredicateOperatorType), SKQuestionCreationDate,
			SK_BOX(NSGreaterThanOrEqualToPredicateOperatorType, NSLessThanOrEqualToPredicateOperatorType), SKQuestionScore,
			SK_BOX(NSContainsPredicateOperatorType), SKQuestionTags,
			nil];
}

+ (NSSet *) requiredPredicateKeyPaths {
	return [NSSet setWithObjects:
			SKQuestionAnswerCount,
			nil];
}

+ (NSDictionary *) recognizedSortDescriptorKeys {
	return [NSDictionary dictionaryWithObjectsAndKeys:
			SKSortCreation, SKQuestionCreationDate,
			SKSortVotes, SKQuestionScore,
			nil];
}

- (void) buildURL {
	NSPredicate * p = [self requestPredicate];
	id answerCount = [p constantValueForLeftKeyPath:SKQuestionAnswerCount];
	if (answerCount == nil || [answerCount isKindOfClass:[NSNumber class]] == NO || [answerCount intValue] != 0) {
		[self setError:SK_PREDERROR(@"Requesting unanswered questions must have 'SKQuestionAnswerCount = 0' in predicate")];
		return;
	}
	
	[[self query] setObject:SKQueryTrue forKey:SKQueryBody];
	
	id tags = [p constantValueForLeftKeyPath:SKQuestionTags];
	if (tags != nil) {
		[[self query] setObject:SKExtractTagName(tags) forKey:SKQueryTagged];
	}
	
	[self setPath:@"/questions/unanswered"];
	
	SKRange dateRange = [p rangeOfConstantValuesForLeftKeyPath:SKQuestionCreationDate];
	if (dateRange.lower != SKNotFound) {
		[[self query] setObject:dateRange.lower forKey:SKQueryFromDate];
	}
	if (dateRange.upper != SKNotFound) {
		[[self query] setObject:dateRange.upper forKey:SKQueryToDate];
	}
	
	if ([self requestSortDescriptor] != nil && ![[[self requestSortDescriptor] key] isEqual:SKQuestionCreationDate]) {
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
