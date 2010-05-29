//
//  SKQuestion.m
//  StackKit
//
//  Created by Dave DeLong on 1/25/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "StackKit_Internal.h"

@implementation SKQuestion

@synthesize tags;

- (id) initWithSite:(SKSite *)aSite postID:(NSNumber *)anID {
	SKQuestion * cachedQuestion = [[aSite cachedPosts] objectForKey:anID];
	if (cachedQuestion != nil) {
		[self release];
		return [cachedQuestion retain];
	}
	
	if (self = [super initWithSite:aSite postID:anID]) {

	}
	return self;
}

@end
