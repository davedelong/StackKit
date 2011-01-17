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

+ (NSDictionary *) recognizedPredicateKeyPaths {
	return [NSDictionary dictionaryWithObjectsAndKeys:
			SK_BOX(NSGreaterThanOrEqualToPredicateOperatorType, NSLessThanOrEqualToPredicateOperatorType), SKUserCreationDate,
			SK_BOX(NSContainsPredicateOperatorType), SKUserBadges,
			nil];
}

+ (NSSet *) requiredPredicateKeyPaths {
	return [NSSet setWithObjects:
			SKUserBadges,
			nil];
}

+ (BOOL) recognizesASortDescriptor {
	return NO;
}

- (void) buildURL {
	NSPredicate * p = [self requestPredicate];
	id badges = [p constantValueForLeftKeyPath:SKUserBadges];
	[self setPath:[NSString stringWithFormat:@"/badges/%@", SKExtractBadgeID(badges)]];
	
	SKRange r = [p rangeOfConstantValuesForLeftKeyPath:SKUserCreationDate];
	if (r.lower != SKNotFound) {
		[[self query] setObject:r.lower forKey:SKQueryFromDate];
	}
	if (r.upper != SKNotFound) {
		[[self query] setObject:r.upper forKey:SKQueryToDate];
	}
	[super buildURL];
}

@end
