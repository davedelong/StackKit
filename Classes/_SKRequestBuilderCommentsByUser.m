//
//  _SKRequestBuilderCommentsByUser.m
//  StackKit
//
//  Created by Dave DeLong on 1/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "_SKRequestBuilderCommentsByUser.h"


@implementation _SKRequestBuilderCommentsByUser

+ (Class) recognizedFetchEntity {
	return [SKComment class];
}

+ (NSSet *) recognizedPredicateKeyPaths {
	return [NSSet setWithObjects:
			SKUserID,
			SKCommentCreationDate,
			SKCommentScore,
			nil];
}

+ (NSSet *) requiredPredicateKeyPaths {
	return [NSSet setWithObjects:
			SKUserID,
			nil];
}

+ (NSSet *) recognizedSortDescriptorKeys {
	return [NSSet setWithObjects:
			SKCommentCreationDate,
			SKCommentScore,
			nil];
}

@end
