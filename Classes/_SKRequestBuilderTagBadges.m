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

+ (NSDictionary *) recognizedPredicateKeyPaths {
	return [NSDictionary dictionaryWithObjectsAndKeys:
			SK_BOX(NSEqualToPredicateOperatorType), SKBadgeTagBased,
			nil];
}

+ (NSSet *) requiredPredicateKeyPaths {
	return [NSSet setWithObjects:
			SKBadgeTagBased,
			nil];
}

+ (NSDictionary *) recognizedSortDescriptorKeys {
	return [NSDictionary dictionaryWithObjectsAndKeys:
			SKSortName, SKBadgeName,
			nil];
}

- (void) buildURL {
	if ([self requestSortDescriptor] != nil && [[self requestSortDescriptor] ascending] == NO) {
		[self setError:SK_SORTERROR(@"badges can only be requested in ascending order")];
	}
	
	id tagBased = [[self requestPredicate] constantValueForLeftKeyPath:SKBadgeTagBased];
	if ([tagBased isKindOfClass:[NSNumber class]] == NO || [tagBased boolValue] == NO) {
		[self setError:SK_PREDERROR(@"Invalid predicate for fetching tag badges")];
	}
	
	[self setPath:@"/badges/tags"];
	[super buildURL];
}

@end
