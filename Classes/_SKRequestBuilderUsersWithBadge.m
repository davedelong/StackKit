//
//  _SKRequestBuilderUsersWithBadge.m
//  StackKit
//
//  Created by Dave DeLong on 1/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "_SKRequestBuilderUsersWithBadge.h"


@implementation _SKRequestBuilderUsersWithBadge

+ (Class) recognizedFetchEntity {
	return [SKUser class];
}

+ (NSSet *) recognizedPredicateKeyPaths {
	return [NSSet setWithObjects:
			SKUserCreationDate,
			SKUserBadges,
			nil];
}

+ (NSSet *) requiredPredicateKeyPaths {
	return [NSSet setWithObjects:
			SKUserBadges,
			nil];
}

@end
