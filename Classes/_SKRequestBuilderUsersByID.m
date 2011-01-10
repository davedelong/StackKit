//
//  _SKRequestBuilderUsersByID.m
//  StackKit
//
//  Created by Dave DeLong on 1/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "_SKRequestBuilderUsersByID.h"


@implementation _SKRequestBuilderUsersByID

+ (Class) recognizedFetchEntity {
	return [SKUser class];
}

+ (NSSet *) recognizedPredicateKeyPaths {
	return [NSSet setWithObjects:
			SKUserID,
			SKUserCreationDate,
			SKUserReputation,
			SKUserDisplayName,
			nil];
}

+ (NSSet *) requiredPredicateKeyPaths {
	return [NSSet setWithObjects:
			SKUserID,
			nil];
}

+ (NSSet *) recognizedSortDescriptorKeys {
	return [NSSet setWithObjects:
			SKUserCreationDate,
			SKUserReputation,
			SKUserDisplayName,
			nil];
}

@end
