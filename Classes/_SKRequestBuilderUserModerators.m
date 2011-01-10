//
//  _SKRequestBuilderUserModerators.m
//  StackKit
//
//  Created by Dave DeLong on 1/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "_SKRequestBuilderUserModerators.h"


@implementation _SKRequestBuilderUserModerators

+ (Class) recognizedFetchEntity {
	return [SKUser class];
}

+ (NSSet *) recognizedPredicateKeyPaths {
	return [NSSet setWithObjects:
			SKUserType,
			SKUserDisplayName,
			SKUserCreationDate,
			SKUserReputation,
			nil];
}

+ (NSSet *) requiredPredicateKeyPaths {
	return [NSSet setWithObjects:
			SKUserType,
			nil];
}

+ (NSSet *) recognizedSortDescriptorKeys {
	return [NSSet setWithObjects:
			SKUserReputation,
			SKUserCreationDate,
			SKUserDisplayName,
			nil];
}

@end
