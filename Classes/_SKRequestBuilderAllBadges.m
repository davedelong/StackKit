//
//  _SKRequestBuilderAllBadges.m
//  StackKit
//
//  Created by Dave DeLong on 1/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "_SKRequestBuilderAllBadges.h"


@implementation _SKRequestBuilderAllBadges

+ (BOOL) recognizesAPredicate {
	return NO;
}

+ (Class) recognizedFetchEntity {
	return [SKBadge class];
}

+ (NSSet *) recognizedSortDescriptorKeys {
	return [NSSet setWithObjects:
			SKBadgeName,
			nil];
}

- (void) buildURL {
	if ([[self requestSortDescriptor] ascending] == NO) {
		[self setError:SK_SORTERROR(@"Badges can only be requested in ascending order")];
	} else {
		[self setPath:@"/badges"];
		[super buildURL];
	}
}

@end
