//
//  SKUserTagsEndpoint.m
//  StackKit
//
//  Created by Dave DeLong on 6/2/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "StackKit_Internal.h"

@implementation SKUserTagsEndpoint

- (BOOL) validatePredicate:(NSPredicate *)predicate {
	if ([predicate isPredicateWithConstantValueEqualToLeftKeyPath:SKTagsParticipatedInByUser]) {
		id user = [predicate constantValueForLeftKeyPath:SKTagsParticipatedInByUser];
		if (user != nil) {
			[self setPath:[NSString stringWithFormat:@"/users/%@/tags", SKExtractUserID(user)]];
			return YES;
		}
	}
	[self setError:[NSError errorWithDomain:SKErrorDomain code:SKErrorCodeInvalidPredicate userInfo:nil]];
	return NO;
}

@end
