//
//  _SKRequestBuilderTagBadges.m
//  StackKit
//
//  Created by Dave DeLong on 1/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "_SKRequestBuilderTagBadges.h"


@implementation _SKRequestBuilderTagBadges

+ (Class) recognizedFetchEntity {
	return [SKBadge class];
}

+ (NSSet *) recognizedPredicateKeyPaths {
	return [NSSet setWithObjects:
			SKBadgeTagBased,
			nil];
}

+ (NSSet *) requiredPredicateKeyPaths {
	return [NSSet setWithObjects:
			SKBadgeTagBased,
			nil];
}

@end
