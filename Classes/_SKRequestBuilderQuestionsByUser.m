//
//  _SKRequestBuilderQuestionsByUser.m
//  StackKit
//
//  Created by Dave DeLong on 1/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "_SKRequestBuilderQuestionsByUser.h"


@implementation _SKRequestBuilderQuestionsByUser

+ (Class) recognizedFetchEntity {
	return [SKQuestion class];
}

+ (NSSet *) recognizedPredicateKeyPaths {
	return [NSSet setWithObjects:
			SKQuestionOwner,
			SKQuestionCreationDate,
			SKQuestionLastActivityDate,
			SKQuestionViewCount,
			SKQuestionScore,
			nil];
}

+ (NSSet *) requiredPredicateKeyPaths {
	return [NSSet setWithObjects:
			SKQuestionOwner,
			nil];
}

+ (NSSet *) recognizedSortDescriptorKeys {
	return [NSSet setWithObjects:
			SKQuestionCreationDate,
			SKQuestionLastActivityDate,
			SKQuestionViewCount,
			SKQuestionScore,
			nil];
}

@end
