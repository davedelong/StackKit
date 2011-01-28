//
//  SKUser+Public.m
//  StackKit
//
//  Created by Dave DeLong on 1/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SKUser+Public.h"
#import "SKFetchRequest.h"
#import "SKTag.h"
#import "SKBadge.h"

@implementation SKUser (Public)

- (BOOL) isEqual:(id)object {
	if ([object isKindOfClass:[self class]] == NO) { return NO; }
	return ([[self userID] isEqual:[object userID]]);
}

- (NSURL *) gravatarIconURL {
	return [self gravatarIconURLForSize:CGSizeMake(80, 80)];
}

- (NSURL *) gravatarIconURLForSize:(CGSize)size {
	if (size.width != size.height) { return nil; }
	int dimension = size.width;
	if (dimension <= 0) { dimension = 1; }
	if (dimension > 512) { dimension = 512; }
	
	return [NSURL URLWithString:[NSString stringWithFormat:@"http://www.gravatar.com/avatar/%@?s=%d", [self emailHash], dimension]];
}

@end
