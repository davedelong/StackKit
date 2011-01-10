//
//  _SKRequestBuilderCommentsForQuestion.m
//  StackKit
//
//  Created by Dave DeLong on 1/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "_SKRequestBuilderCommentsForQuestion.h"


@implementation _SKRequestBuilderCommentsForQuestion

+ (Class) recognizedFetchEntity {
	return [SKComment class];
}

+ (NSSet *) recognizedPredicateKeyPaths {
	return [NSSet setWithObjects:
			SKQuestionID,
			SKCommentCreationDate,
			SKCommentScore,
			nil];
}

+ (NSSet *) requiredPredicateKeyPaths {
	return [NSSet setWithObjects:
			SKQuestionID,
			nil];
}

+ (NSSet *) recognizedSortDescriptorKeys {
	return [NSSet setWithObjects:
			SKCommentCreationDate,
			SKCommentScore,
			nil];
}

@end
