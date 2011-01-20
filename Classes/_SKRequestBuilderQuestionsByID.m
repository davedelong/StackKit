//
//  _SKRequestBuilderQuestionsByID.m
//  StackKit
//
//  Created by Dave DeLong on 1/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "_SKRequestBuilderQuestionsByID.h"


@implementation _SKRequestBuilderQuestionsByID

+ (Class) recognizedFetchEntity {
	return [SKQuestion class];
}

+ (NSDictionary *) recognizedPredicateKeyPaths {
	return [NSDictionary dictionaryWithObjectsAndKeys:
			SK_BOX(NSEqualToPredicateOperatorType, NSInPredicateOperatorType), SKQuestionID,
			SK_BOX(NSGreaterThanOrEqualToPredicateOperatorType, NSLessThanOrEqualToPredicateOperatorType), SKQuestionCreationDate,
			SK_BOX(NSGreaterThanOrEqualToPredicateOperatorType, NSLessThanOrEqualToPredicateOperatorType), SKQuestionLastActivityDate,
			SK_BOX(NSGreaterThanOrEqualToPredicateOperatorType, NSLessThanOrEqualToPredicateOperatorType), SKQuestionScore,
			SK_BOX(NSGreaterThanOrEqualToPredicateOperatorType, NSLessThanOrEqualToPredicateOperatorType), SKQuestionViewCount,
			nil];
}

+ (NSSet *) requiredPredicateKeyPaths {
	return [NSSet setWithObjects:
			SKQuestionID,
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
	[[self query] setObject:SKQueryTrue forKey:SKQueryBody];
	
	id questionIDs = [p constantValueForLeftKeyPath:SKQuestionID];
	[self setPath:[NSString stringWithFormat:@"/questions/%@", SKExtractQuestionID(questionIDs)]];
	
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
