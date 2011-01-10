//
//  _SKRequestBuilderCommentsToUser.m
//  StackKit
//
//  Created by Dave DeLong on 1/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "_SKRequestBuilderCommentsToUser.h"


@implementation _SKRequestBuilderCommentsToUser

+ (Class) recognizedFetchEntity {
	return [SKComment class];
}

+ (NSSet *) recognizedPredicateKeyPaths {
	return [NSSet setWithObjects:
			SKCommentInReplyToUser,
			SKCommentCreationDate,
			SKCommentScore,
			nil];
}

+ (NSSet *) requiredPredicateKeyPaths {
	return [NSSet setWithObjects:
			SKCommentInReplyToUser,
			nil];
}

+ (NSSet *) recognizedSortDescriptorKeys {
	return [NSSet setWithObjects:
			SKCommentCreationDate,
			SKCommentScore,
			nil];
}

@end
