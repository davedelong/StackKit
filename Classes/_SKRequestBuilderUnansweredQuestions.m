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
			SK_BOX(NSGreaterThanOrEqualToPredicateOperatorType, NSLessThanOrEqualToPredicateOperatorType), SKQuestionAnswerCount,
			SK_BOX(NSGreaterThanOrEqualToPredicateOperatorType, NSLessThanOrEqualToPredicateOperatorType), SKQuestionCreationDate,
			SK_BOX(NSGreaterThanOrEqualToPredicateOperatorType, NSLessThanOrEqualToPredicateOperatorType), SKQuestionScore,
			nil];
}

+ (NSSet *) requiredPredicateKeyPaths {
	return [NSSet setWithObjects:
			SKQuestionAnswerCount,
			nil];
}

+ (NSSet *) recognizedSortDescriptorKeys {
	return [NSSet setWithObjects:
			SKQuestionCreationDate,
			SKQuestionScore,
			nil];
}

@end
