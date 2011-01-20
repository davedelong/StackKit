//
//  _SKRequestBuilderAnswersForUser.m
//  StackKit
//
//  Created by Dave DeLong on 1/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "_SKRequestBuilderAnswersForUser.h"


@implementation _SKRequestBuilderAnswersForUser

+ (Class) recognizedFetchEntity {
	return [SKAnswer class];
}

+ (NSDictionary *) recognizedPredicateKeyPaths {
	return [NSDictionary dictionaryWithObjectsAndKeys:
			SK_BOX(NSEqualToPredicateOperatorType, NSInPredicateOperatorType), SKAnswerOwner,
			SK_BOX(NSGreaterThanOrEqualToPredicateOperatorType, NSLessThanOrEqualToPredicateOperatorType), SKAnswerCreationDate,
			SK_BOX(NSGreaterThanOrEqualToPredicateOperatorType, NSLessThanOrEqualToPredicateOperatorType), SKAnswerLastActivityDate,
			SK_BOX(NSGreaterThanOrEqualToPredicateOperatorType, NSLessThanOrEqualToPredicateOperatorType), SKAnswerViewCount,
			SK_BOX(NSGreaterThanOrEqualToPredicateOperatorType, NSLessThanOrEqualToPredicateOperatorType), SKAnswerScore,
			nil];
}

+ (NSSet *) requiredPredicateKeyPaths {
	return [NSSet setWithObjects:
			SKAnswerOwner,
			nil];
}

+ (NSDictionary *) recognizedSortDescriptorKeys {
	return [NSDictionary dictionaryWithObjectsAndKeys:
			SKSortCreation, SKAnswerCreationDate,
			SKSortViews, SKAnswerViewCount,
			SKSortActivity, SKAnswerLastActivityDate,
			SKSortVotes, SKAnswerScore,
			nil];
}

- (void) buildURL {
	NSPredicate * p = [self requestPredicate];
	
	id users = [p constantValueForLeftKeyPath:SKAnswerOwner];
	[self setPath:[NSString stringWithFormat:@"/users/%@/answers", SKExtractUserID(users)]];
	[[self query] setObject:SKQueryTrue forKey:SKQueryBody];
	
	SKRange dateRange = [p rangeOfConstantValuesForLeftKeyPath:SKAnswerCreationDate];
	if (dateRange.lower != SKNotFound) {
		[[self query] setObject:dateRange.lower forKey:SKQueryFromDate];
	}
	if (dateRange.upper != SKNotFound) {
		[[self query] setObject:dateRange.upper forKey:SKQueryToDate];
	}
	
	if ([self requestSortDescriptor] != nil && ![[[self requestSortDescriptor] key] isEqual:SKAnswerCreationDate]) {
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
