//
//  _SKRequestBuilderUnansweredQuestionsByUser.m
//  StackKit
//
//  Created by Dave DeLong on 2/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "_SKRequestBuilderUnansweredQuestionsByUser.h"
#import "SKQuestion.h"

@implementation _SKRequestBuilderUnansweredQuestionsByUser

+ (Class) recognizedFetchEntity {
	return [SKQuestion class];
}

+ (NSDictionary *) recognizedPredicateKeyPaths {
	return [NSDictionary dictionaryWithObjectsAndKeys:
			SK_BOX(NSGreaterThanOrEqualToPredicateOperatorType, NSLessThanOrEqualToPredicateOperatorType, NSEqualToPredicateOperatorType), @"answers.@count",
			SK_BOX(NSEqualToPredicateOperatorType, NSInPredicateOperatorType), @"owner",
			SK_BOX(NSGreaterThanOrEqualToPredicateOperatorType, NSLessThanOrEqualToPredicateOperatorType), @"creationDate",
			SK_BOX(NSGreaterThanOrEqualToPredicateOperatorType, NSLessThanOrEqualToPredicateOperatorType), @"lastActivityDate",
			SK_BOX(NSGreaterThanOrEqualToPredicateOperatorType, NSLessThanOrEqualToPredicateOperatorType), @"viewCount",
			SK_BOX(NSGreaterThanOrEqualToPredicateOperatorType, NSLessThanOrEqualToPredicateOperatorType), @"score",
			SK_BOX(NSContainsPredicateOperatorType), @"tags",
			nil];
}

+ (NSSet *) requiredPredicateKeyPaths {
	return [NSSet setWithObjects:
			@"answers.@count",
            @"owner",
			nil];
}

+ (NSDictionary *) recognizedSortDescriptorKeys {
	return [NSDictionary dictionaryWithObjectsAndKeys:
			SKSortCreation, @"creationDate",
            SKSortActivity, @"lastActivityDate",
            SKSortViews, @"viewCount",
			SKSortVotes, @"score",
			nil];
}

- (void) buildURL {
	NSPredicate * p = [self requestPredicate];
	id answerCount = [p sk_constantValueForLeftKeyPath:@"answers.@count"];
	if (answerCount == nil || [answerCount isKindOfClass:[NSNumber class]] == NO || [answerCount intValue] != 0) {
		[self setError:SK_PREDERROR(@"Requesting unanswered questions must have 'answers.@count = 0' in predicate")];
		return;
	}
	
	[[self query] setObject:SKQueryTrue forKey:SKQueryAnswers];
	[[self query] setObject:SKQueryTrue forKey:SKQueryBody];
	[[self query] setObject:SKQueryTrue forKey:SKQueryComments];
	
	id tags = [p sk_constantValueForLeftKeyPath:@"tags"];
	if (tags != nil) {
		[[self query] setObject:SKExtractTagName(tags) forKey:SKQueryTagged];
	}
	
	id users = [p sk_constantValueForLeftKeyPath:@"owner"];
	[self setPath:[NSString stringWithFormat:@"/users/%@/questions/no-answers", SKExtractUserID(users)]];
	
	SKRange dateRange = [p sk_rangeOfConstantValuesForLeftKeyPath:@"creationDate"];
	if (dateRange.lower != SKNotFound) {
		[[self query] setObject:dateRange.lower forKey:SKQueryFromDate];
	}
	if (dateRange.upper != SKNotFound) {
		[[self query] setObject:dateRange.upper forKey:SKQueryToDate];
	}
	
	if ([self requestSortDescriptor] != nil && ![[[self requestSortDescriptor] key] isEqual:@"creationDate"]) {
		SKRange sortRange = [p sk_rangeOfConstantValuesForLeftKeyPath:[[self requestSortDescriptor] key]];
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
