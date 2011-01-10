//
//  _SKRequestBuilderBadgesForUser.m
//  StackKit
//
//  Created by Dave DeLong on 1/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "_SKRequestBuilderBadgesForUser.h"


@implementation _SKRequestBuilderBadgesForUser

+ (Class) recognizedFetchEntity {
	return [SKBadge class];
}

+ (NSSet *) recognizedPredicateKeyPaths {
	return [NSSet setWithObjects:
			SKBadgesAwardedToUser,
			nil];
}

+ (NSSet *) requiredPredicateKeyPaths {
	return [NSSet setWithObjects:
			SKBadgesAwardedToUser,
			nil];
}

@end
