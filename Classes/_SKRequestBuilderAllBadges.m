//
//  _SKRequestBuilderAllBadges.m
//  StackKit
//
//  Created by Dave DeLong on 1/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "_SKRequestBuilderAllBadges.h"


@implementation _SKRequestBuilderAllBadges

+ (Class) recognizedFetchEntity {
	return [SKBadge class];
}

+ (NSSet *) recognizedSortDescriptorKeys {
	return [NSSet setWithObjects:
			SKBadgeName,
			nil];
}

@end
