//
//  _SKRequestBuilderCommentsFromUserToUser.m
//  StackKit
//
//  Created by Dave DeLong on 1/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "_SKRequestBuilderCommentsFromUserToUser.h"


@implementation _SKRequestBuilderCommentsFromUserToUser

+ (Class) recognizedFetchEntity {
	return [SKComment class];
}

+ (NSDictionary *) recognizedPredicateKeyPaths {
	return [NSDictionary dictionaryWithObjectsAndKeys:
			SK_BOX(NSEqualToPredicateOperatorType, NSInPredicateOperatorType), SKUserID,
			SK_BOX(NSEqualToPredicateOperatorType, NSInPredicateOperatorType), SKCommentInReplyToUser,
			SK_BOX(NSGreaterThanOrEqualToPredicateOperatorType, NSLessThanOrEqualToPredicateOperatorType), SKCommentCreationDate,
			SK_BOX(NSGreaterThanOrEqualToPredicateOperatorType, NSLessThanOrEqualToPredicateOperatorType), SKCommentScore,
			nil];
}

+ (NSSet *) requiredPredicateKeyPaths {
	return [NSSet setWithObjects:
			SKUserID,
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
