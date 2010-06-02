//
//  SKAllBadgesEndpoint.m
//  StackKit
//
//  Created by Dave DeLong on 6/2/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "StackKit_Internal.h"

@implementation SKAllBadgesEndpoint

- (BOOL) validatePredicate:(NSPredicate *)predicate {
	if (predicate == nil) {
		return YES;
	}
	[self setError:[NSError errorWithDomain:SKErrorDomain code:SKErrorCodeInvalidPredicate userInfo:nil]];
	return NO;
}

@end
