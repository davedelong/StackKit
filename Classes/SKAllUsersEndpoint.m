//
//  SKAllUsersEndpoint.m
//  StackKit
//
//  Created by Dave DeLong on 6/2/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "StackKit_Internal.h"


@implementation SKAllUsersEndpoint

- (BOOL) validatePredicate:(NSPredicate *)predicate {
	if (predicate != nil) {
		[self setError:[NSError errorWithDomain:SKErrorDomain code:SKErrorCodeInvalidPredicate userInfo:nil]];
		return NO;
	}
	
	[self setPath:@"/users"];
	return YES;
}

@end
