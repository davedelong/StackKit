//
//  _SKRequestBuilderNameBadges.m
//  StackKit
//
//  Created by Dave DeLong on 1/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "_SKRequestBuilderNameBadges.h"


@implementation _SKRequestBuilderNameBadges

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
