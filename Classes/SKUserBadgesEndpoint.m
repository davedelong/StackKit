//
//  SKUserBadgesEndpoint.m
//  StackKit
//
//  Created by Dave DeLong on 6/2/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "StackKit_Internal.h"

@implementation SKUserBadgesEndpoint

- (BOOL) validatePredicate:(NSPredicate *)predicate {
	if ([predicate isPredicateWithConstantValueEqualToLeftKeyPath:SKBadgesAwardedToUser]) {
		id user = [predicate constantValueForLeftKeyPath:SKBadgesAwardedToUser];
		if (user != nil) {
			[self setPath:[NSString stringWithFormat:@"/users/%@/badges", SKExtractUserID(user)]];
			return YES;
		}
	}
	[self setError:[NSError errorWithDomain:SKErrorDomain code:SKErrorCodeInvalidPredicate userInfo:nil]];
	return NO;
}

@end
