//
//  _SKRequestBuilderAnswersForQuestion.m
//  StackKit
//
//  Created by Dave DeLong on 1/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "_SKRequestBuilderAnswersForQuestion.h"


@implementation _SKRequestBuilderAnswersForQuestion

+ (Class) recognizedFetchEntity {
	return [SKAnswer class];
}

+ (NSSet *) recognizedPredicateKeyPaths {
	return [NSSet setWithObjects:
			SKQuestionID,
			SKAnswerCreationDate,
			SKAnswerLastActivityDate,
			SKAnswerViewCount,
			SKAnswerScore,
			nil];
}

+ (NSSet *) requiredPredicateKeyPaths {
	return [NSSet setWithObjects:
			SKQuestionID,
			nil];
}

+ (NSSet *) recognizedSortDescriptorKeys {
	return [NSSet setWithObjects:
			SKAnswerCreationDate,
			SKAnswerLastActivityDate,
			SKAnswerViewCount,
			SKAnswerScore,
			nil];
}

@end
