//
//  SKBadgeEndpoint.m
//  StackKit
//
//  Created by Dave DeLong on 6/2/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "StackKit_Internal.h"


@implementation SKBadgeEndpoint

- (BOOL) validateEntity:(Class)entity {
	if (entity == [SKBadge class]) {
		return YES;
	}
	[self setError:[NSError errorWithDomain:SKErrorDomain code:SKErrorCodeInvalidEntity userInfo:nil]];
	return NO;
}

- (BOOL) validateSortDescriptor:(NSSortDescriptor *)sortDescriptor {
	if (sortDescriptor == nil) {
		return YES;
	}
	[self setError:[NSError errorWithDomain:SKErrorDomain code:SKErrorCodeInvalidSort userInfo:nil]];
	return NO;
}

@end
