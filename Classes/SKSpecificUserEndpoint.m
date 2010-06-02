//
//  SKSpecificUserEndpoint.m
//  StackKit
//
//  Created by Dave DeLong on 6/2/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "StackKit_Internal.h"


@implementation SKSpecificUserEndpoint

- (BOOL) validatePredicate:(NSPredicate *)predicate {
	if ([predicate isPredicateWithConstantValueEqualToLeftKeyPath:SKUserID] == NO) {
		goto errorExit;
	}
	
	id userID = [predicate constantValueForLeftKeyPath:SKUserID];
	if (userID == nil) { goto errorExit; }
	
	[self setPath:[NSString stringWithFormat:@"/users/%@", SKExtractUserID(userID)]];
	return YES;
	
errorExit:
	[self setError:[NSError errorWithDomain:SKErrorDomain code:SKErrorCodeInvalidPredicate userInfo:nil]];
	return NO;
}

@end
