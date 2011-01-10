//
//  _SKRequestBuilderUserTags.m
//  StackKit
//
//  Created by Dave DeLong on 1/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "_SKRequestBuilderUserTags.h"


@implementation _SKRequestBuilderUserTags

+ (Class) recognizedFetchEntity {
	return [SKTag class];
}

+ (NSSet *) recognizedPredicateKeyPaths {
	return [NSSet setWithObjects:
			SKTagsParticipatedInByUser,
			SKTagNumberOfTaggedQuestions,
			SKTagLastUsedDate,
			SKTagName,
			nil];
}

+ (NSSet *) requiredPredicateKeyPaths {
	return [NSSet setWithObjects:
			SKTagsParticipatedInByUser,
			nil];
}

+ (NSSet *) recognizedSortDescriptorKeys {
	return [NSSet setWithObjects:
			SKTagNumberOfTaggedQuestions,
			SKTagLastUsedDate,
			SKTagName,
			nil];
}

@end
