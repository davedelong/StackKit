//
//  _SKRequestBuilderQuestions.m
//  StackKit
//
//  Created by Dave DeLong on 1/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "_SKRequestBuilderQuestions.h"


@implementation _SKRequestBuilderQuestions

+ (Class) recognizedFetchEntity {
	return [SKQuestion class];
}

+ (NSDictionary *) recognizedPredicateKeyPaths {
	return [NSDictionary dictionaryWithObjectsAndKeys:
			SK_BOX(NSGreaterThanOrEqualToPredicateOperatorType, NSLessThanOrEqualToPredicateOperatorType), SKQuestionCreationDate,
			SK_BOX(NSContainsPredicateOperatorType), SKQuestionTags,
			SK_BOX(NSGreaterThanOrEqualToPredicateOperatorType, NSLessThanOrEqualToPredicateOperatorType), SKQuestionLastActivityDate,
			SK_BOX(NSGreaterThanOrEqualToPredicateOperatorType, NSLessThanOrEqualToPredicateOperatorType), SKQuestionScore,
//			SKQuestionIsFeatured,
//			SKQuestionIsHot,
//			SKQuestionWeek,
//			SKQuestionMonth,
			nil];
}

+ (NSSet *) recognizedSortDescriptorKeys {
	return [NSSet setWithObjects:
			SKQuestionLastActivityDate,
			SKQuestionCreationDate,
			SKQuestionScore,
//			SKQuestionIsFeatured,
//			SKQuestionIsHot,
//			SKQuestionWeek,
//			SKQuestionMonth,
			nil];
}

@end
