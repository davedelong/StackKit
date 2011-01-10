//
//  _SKRequestBuilderAnswerComments.m
//  StackKit
//
//  Created by Dave DeLong on 1/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "_SKRequestBuilderCommentsForAnswer.h"


@implementation _SKRequestBuilderCommentsForAnswer

+ (Class) recognizedFetchEntity {
	return [SKComment class];
}

+ (NSSet *) recognizedPredicateKeyPaths {
	return [NSSet setWithObjects:
			SKAnswerID,
			SKCommentCreationDate,
			SKCommentScore,
			nil];
}

// Either SKAnswerID or SKCommentAnswer are required, but SKAnswerID has the same value as SKCommentAnswer
+ (NSSet *) requiredPredicateKeyPaths {
	return [NSSet setWithObjects:
			SKAnswerID,
			nil];
}

+ (NSSet *) recognizedSortDescriptorKeys {
	return [NSSet setWithObjects:
			SKCommentCreationDate,
			SKCommentScore,
			nil];
}

@end
