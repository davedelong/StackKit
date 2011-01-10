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

+ (NSSet *) recognizedPredicateKeyPaths {
	return [NSSet setWithObjects:
			SKAnswerOwner,
			SKAnswerCreationDate,
			SKAnswerLastActivityDate,
			SKAnswerViewCount,
			SKAnswerScore,
			nil];
}

+ (NSSet *) requiredPredicateKeyPaths {
	return [NSSet setWithObjects:
			SKAnswerOwner,
			nil];
}

+ (NSSet *) recognizedSortDescriptorKeys {
	return [NSSet setWithObjects:
			SKAnswerCreationDate,
			SKAnswerViewCount,
			SKAnswerLastActivityDate,
			SKAnswerScore,
			nil];
}

@end
