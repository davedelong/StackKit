//
//  SKTagBadgesEndpoint.m
//  StackKit
//
//  Created by Dave DeLong on 6/2/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "StackKit_Internal.h"

@implementation SKTagBadgesEndpoint

- (BOOL) validatePredicate:(NSPredicate *)predicate {
	if ([predicate isPredicateWithConstantValueEqualToLeftKeyPath:SKBadgeTagBased]) {
		id tagBased = [predicate constantValueForLeftKeyPath:SKBadgeTagBased];
		if ([tagBased boolValue] == YES) {
			[self setPath:@"/badges/tags"];
			return YES;
		}
	}
	[self setError:[NSError errorWithDomain:SKErrorDomain code:SKErrorCodeInvalidPredicate userInfo:nil]];
	return NO;
}

@end
