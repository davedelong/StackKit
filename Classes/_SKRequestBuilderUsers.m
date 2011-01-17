//
//  _SKRequestBuilderUsers.m
//  StackKit
//
//  Created by Dave DeLong on 1/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "_SKRequestBuilderUsers.h"


@implementation _SKRequestBuilderUsers

+ (Class) recognizedFetchEntity {
	return [SKUser class];
}

+ (NSDictionary *) recognizedPredicateKeyPaths {
	return [NSDictionary dictionaryWithObjectsAndKeys:
			SK_BOX(NSContainsPredicateOperatorType), SKUserDisplayName,
			SK_BOX(NSGreaterThanOrEqualToPredicateOperatorType, NSLessThanOrEqualToPredicateOperatorType), SKUserCreationDate,
			SK_BOX(NSGreaterThanOrEqualToPredicateOperatorType, NSLessThanOrEqualToPredicateOperatorType), SKUserReputation,
			nil];
}

+ (NSSet *) recognizedSortDescriptorKeys {
	return [NSSet setWithObjects:
			SKUserDisplayName,
			SKUserCreationDate,
			SKUserReputation,
			nil];
}

- (void) buildURL {
	NSPredicate * p = [self requestPredicate];
	
	[self setPath:@"/users"];
	
	SKRange dateRange = [p rangeOfConstantValuesForLeftKeyPath:SKUserCreationDate];
	if (dateRange.lower != SKNotFound) {
		[[self query] setObject:[NSNumber numberWithUnsignedInteger:dateRange.lower] forKey:SKQueryFromDate];
	}
	if (dateRange.upper != SKNotFound) {
		[[self query] setObject:[NSNumber numberWithUnsignedInteger:dateRange.upper] forKey:SKQueryToDate];
	}
	
	if ([self requestSortDescriptor] != nil && ![[[self requestSortDescriptor] key] isEqual:SKUserCreationDate]) {
		SKRange sortRange = [p rangeOfConstantValuesForLeftKeyPath:[[self requestSortDescriptor] key]];
		if (sortRange.lower != SKNotFound) {
			[[self query] setObject:[NSNumber numberWithUnsignedInteger:sortRange.lower] forKey:SKQueryMinSort];
		}
		if (sortRange.upper != SKNotFound) {
			[[self query] setObject:[NSNumber numberWithUnsignedInteger:sortRange.upper] forKey:SKQueryMaxSort];
		}
	}
	
	id filter = [p constantValueForLeftKeyPath:SKUserDisplayName];
	if (filter != nil) {
		[[self query] setObject:filter forKey:SKQueryFilter];
	}
	
	[super buildURL];
}

@end
