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

+ (NSSet *) recognizedPredicateKeyPaths {
	return [NSSet setWithObjects:
			SKQuestionID,
			SKQuestionCreationDate,
			SKQuestionLastActivityDate,
			SKQuestionScore,
			SKQuestionViewCount,
			nil];
}

+ (NSSet *) requiredPredicateKeyPaths {
	return [NSSet setWithObjects:
			SKQuestionID,
			nil];
}

+ (NSSet *) recognizedSortDescriptorKeys {
	return [NSSet setWithObjects:
			SKQuestionLastActivityDate,
			SKQuestionViewCount,
			SKQuestionCreationDate,
			SKQuestionScore,
			nil];
}

@end
