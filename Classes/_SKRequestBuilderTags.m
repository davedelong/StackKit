//
//  _SKRequestBuilderTags.m
//  StackKit
//
//  Created by Dave DeLong on 1/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "_SKRequestBuilderTags.h"

@implementation _SKRequestBuilderTags

+ (Class) recognizedFetchEntity {
	return [SKTag class];
}

+ (NSDictionary *) recognizedPredicateKeyPaths {
	return [NSDictionary dictionaryWithObjectsAndKeys:
			SK_BOX(NSGreaterThanOrEqualToPredicateOperatorType, NSLessThanOrEqualToPredicateOperatorType), SKTagCount,
			SK_BOX(NSGreaterThanOrEqualToPredicateOperatorType, NSLessThanOrEqualToPredicateOperatorType), SKTagLastUsedDate,
			SK_BOX(NSContainsPredicateOperatorType), SKTagName,
			nil];
}

+ (NSDictionary *) recognizedSortDescriptorKeys {
	return [NSDictionary dictionaryWithObjectsAndKeys:
			SKSortPopular, SKTagCount,
			SKSortActivity, SKTagLastUsedDate,
			SKSortName, SKTagName,
			nil];
}

- (void) buildURL {
	NSPredicate *p = [self requestPredicate];
	[self setPath:@"/tags"];
	
	id filter = [p constantValueForLeftKeyPath:SKTagName];
	if (filter) {
		[[self query] setObject:filter forKey:SKQueryFilter];
	}
	
	if ([self requestSortDescriptor] != nil) {
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
