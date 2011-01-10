//
//  _SKRequestBuilderFavoritedQuestions.m
//  StackKit
//
//  Created by Dave DeLong on 1/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "_SKRequestBuilderFavoritedQuestions.h"


@implementation _SKRequestBuilderFavoritedQuestions

+ (Class) recognizedFetchEntity {
	return [SKQuestion class];
}

+ (NSSet *) recognizedPredicateKeyPaths {
	return [NSSet setWithObjects:
			SKQuestionsFavoritedByUser,
			SKQuestionCreationDate,
			SKQuestionLastActivityDate,
			SKQuestionViewCount,
			SKQuestionFavoritedDate,
			SKQuestionScore,
			nil];
}

+ (NSSet *) requiredPredicateKeyPaths {
	return [NSSet setWithObjects:
			SKQuestionsFavoritedByUser,
			nil];
}

+ (NSSet *) recognizedSortDescriptorKeys {
	return [NSSet setWithObjects:
			SKQuestionCreationDate,
			SKQuestionLastActivityDate,
			SKQuestionViewCount,
			SKQuestionFavoritedDate,
			SKQuestionScore,
			nil];
}

@end
