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

+ (NSSet *) recognizedSortDescriptorKeys {
	return [NSSet setWithObjects:
			SKBadgeName,
			nil];
}

- (void) buildURL {
	if ([self requestSortDescriptor] != nil && [[self requestSortDescriptor] ascending] == NO) {
		[self setError:SK_SORTERROR(@"badges can only be requested in ascending order")];
	}
	
	id tagBased = [[self requestPredicate] constantValueForLeftKeyPath:SKBadgeTagBased];
	if ([tagBased isKindOfClass:[NSNumber class]] == NO || [tagBased boolValue] == YES) {
		[self setError:SK_PREDERROR(@"Invalid predicate for fetching named badges")];
	}
	
	[self setPath:@"/badges/name"];
	[super buildURL];
}

@end
