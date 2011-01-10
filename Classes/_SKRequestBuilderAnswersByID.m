//
//  _SKRequestBuilderAnswersByID.m
//  StackKit
//
//  Created by Dave DeLong on 1/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "_SKRequestBuilderAnswersByID.h"


@implementation _SKRequestBuilderAnswersByID

+ (Class) recognizedFetchEntity {
	return [SKAnswer class];
}

+ (NSSet *) recognizedPredicateKeyPaths {
	return [NSSet setWithObjects:
			SKAnswerID,
			SKAnswerCreationDate,
			
			SKAnswerLastActivityDate,
			SKAnswerViewCount,
			SKAnswerScore,
			nil];
}

+ (NSSet *) requiredPredicateKeyPaths {
	return [NSSet setWithObjects:
			SKAnswerID,
			nil];
}

+ (NSSet *) recognizedSortDescriptorKeys {
	return [NSSet setWithObjects:
			SKAnswerLastActivityDate,
			SKAnswerViewCount,
			SKAnswerCreationDate,
			SKAnswerScore,
			nil];
}

@end
