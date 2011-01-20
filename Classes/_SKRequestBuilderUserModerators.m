//
//  _SKRequestBuilderUserModerators.m
//  StackKit
//
//  Created by Dave DeLong on 1/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "_SKRequestBuilderUserModerators.h"


@implementation _SKRequestBuilderUserModerators

+ (Class) recognizedFetchEntity {
	return [SKUser class];
}

+ (NSDictionary *) recognizedPredicateKeyPaths {
	return [NSDictionary dictionaryWithObjectsAndKeys:
			SK_BOX(NSEqualToPredicateOperatorType), SKUserType,
			SK_BOX(NSContainsPredicateOperatorType, NSGreaterThanOrEqualToPredicateOperatorType, NSLessThanOrEqualToPredicateOperatorType), SKUserDisplayName,
			SK_BOX(NSGreaterThanOrEqualToPredicateOperatorType, NSLessThanOrEqualToPredicateOperatorType), SKUserCreationDate,
			SK_BOX(NSGreaterThanOrEqualToPredicateOperatorType, NSLessThanOrEqualToPredicateOperatorType), SKUserReputation,
			nil];
}

+ (NSSet *) requiredPredicateKeyPaths {
	return [NSSet setWithObjects:
			SKUserType,
			nil];
}

+ (NSDictionary *) recognizedSortDescriptorKeys {
	return [NSDictionary dictionaryWithObjectsAndKeys:
			SKSortReputation, SKUserReputation,
			SKSortCreation, SKUserCreationDate,
			SKSortName, SKUserDisplayName,
			nil];
}

- (void) buildURL {
	NSPredicate * p = [self requestPredicate];
	id userType = [p constantValueForLeftKeyPath:SKUserType];
	if ([userType respondsToSelector:@selector(intValue)]) {
		int type = [userType intValue];
		if (type != SKUserTypeModerator) {
			[self setError:SK_PREDERROR(@"Requesting moderators requires a SKUserType = SKUserTypeModerator predicate")];
			return;
		}
	}
	
	id filter = [p constantValueForLeftKeyPath:SKUserDisplayName];
	if (filter != nil) {
		[[self query] setObject:filter forKey:SKQueryFilter];
	}
	
	[self setPath:@"/users/moderators"];
	
	SKRange dateRange = [p rangeOfConstantValuesForLeftKeyPath:SKUserCreationDate];
	if (dateRange.lower != SKNotFound) {
		[[self query] setObject:dateRange.lower forKey:SKQueryFromDate];
	}
	if (dateRange.upper != SKNotFound) {
		[[self query] setObject:dateRange.upper forKey:SKQueryToDate];
	}
	
	if ([self requestSortDescriptor] != nil && ![[[self requestSortDescriptor] key] isEqual:SKUserCreationDate]) {
		SKRange sortRange = [p rangeOfConstantValuesForLeftKeyPath:[[self requestSortDescriptor] key]];
		if (sortRange.lower != SKNotFound) {
			[[self query] setObject:sortRange.lower forKey:SKQueryMinSort];
		}
		if (sortRange.upper != SKNotFound) {
			[[self query] setObject:sortRange.upper forKey:SKQueryMaxSort];
		}
	}
	
	[super buildURL];
}

@end
