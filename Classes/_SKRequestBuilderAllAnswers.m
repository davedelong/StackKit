//
//  _SKRequestBuilderAllAnswers.m
//  StackKit
//
//  Created by Dave DeLong on 2/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "_SKRequestBuilderAllAnswers.h"
#import "SKAnswer.h"

@implementation _SKRequestBuilderAllAnswers

+ (Class) recognizedFetchEntity {
	return [SKAnswer class];
}

+ (NSDictionary *) recognizedPredicateKeyPaths {
	return [NSDictionary dictionaryWithObjectsAndKeys:
			SK_BOX(NSGreaterThanOrEqualToPredicateOperatorType, NSLessThanOrEqualToPredicateOperatorType), @"creationDate",
			SK_BOX(NSGreaterThanOrEqualToPredicateOperatorType, NSLessThanOrEqualToPredicateOperatorType), @"lastActivityDate",
			SK_BOX(NSGreaterThanOrEqualToPredicateOperatorType, NSLessThanOrEqualToPredicateOperatorType), @"score",
			nil];
}

+ (NSDictionary *) recognizedSortDescriptorKeys {
	return [NSDictionary dictionaryWithObjectsAndKeys:
			SKSortActivity, @"lastActivityDate",
			SKSortCreation, @"creationDate",
			SKSortVotes, @"score",
			nil];
}

- (void) buildURL {
    [[self query] setObject:SKQueryTrue forKey:SKQueryBody];
    [[self query] setObject:SKQueryTrue forKey:SKQueryAnswers];
    [[self query] setObject:SKQueryTrue forKey:SKQueryComments];
    
    
	NSPredicate * p = [self requestPredicate];
	[self setPath:@"/answers"];
	
	SKRange dateRange = [p rangeOfConstantValuesForLeftKeyPath:@"creationDate"];
	if (dateRange.lower != SKNotFound) {
		[[self query] setObject:dateRange.lower forKey:SKQueryFromDate];
	}
	if (dateRange.upper != SKNotFound) {
		[[self query] setObject:dateRange.upper forKey:SKQueryToDate];
	}
	
	if ([self requestSortDescriptor] != nil && ![[[self requestSortDescriptor] key] isEqual:@"creationDate"]) {
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
