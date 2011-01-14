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

+ (NSDictionary *) recognizedPredicateKeyPaths {
	return [NSDictionary dictionaryWithObjectsAndKeys:
			SK_BOX(NSEqualToPredicateOperatorType, NSInPredicateOperatorType), SKQuestionOwner,
			SK_BOX(NSGreaterThanOrEqualToPredicateOperatorType, NSLessThanOrEqualToPredicateOperatorType), SKQuestionCreationDate,
			SK_BOX(NSGreaterThanOrEqualToPredicateOperatorType, NSLessThanOrEqualToPredicateOperatorType), SKQuestionLastActivityDate,
			SK_BOX(NSGreaterThanOrEqualToPredicateOperatorType, NSLessThanOrEqualToPredicateOperatorType), SKQuestionViewCount,
			SK_BOX(NSGreaterThanOrEqualToPredicateOperatorType, NSLessThanOrEqualToPredicateOperatorType), SKQuestionScore,
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
