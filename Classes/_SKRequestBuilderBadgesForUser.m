//
//  _SKRequestBuilderBadgesForUser.m
//  StackKit
//
//  Created by Dave DeLong on 1/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "_SKRequestBuilderBadgesForUser.h"


@implementation _SKRequestBuilderBadgesForUser

+ (Class) recognizedFetchEntity {
	return [SKBadge class];
}

+ (NSDictionary *) recognizedPredicateKeyPaths {
	return [NSDictionary dictionaryWithObjectsAndKeys:
			SK_BOX(NSEqualToPredicateOperatorType, NSInPredicateOperatorType), SKBadgesAwardedToUser,
			nil];
}

+ (NSSet *) requiredPredicateKeyPaths {
	return [NSSet setWithObjects:
			SKBadgesAwardedToUser,
			nil];
}

+ (BOOL) recognizesASortDescriptor {
	return NO;
}

- (void) buildURL {
	NSPredicate * p = [self requestPredicate];
	
	id users = [p constantValueForLeftKeyPath:SKBadgesAwardedToUser];
	[self setPath:[NSString stringWithFormat:@"/users/%@/badges", SKExtractUserID(users)]];
	
	[super buildURL];
}

@end
