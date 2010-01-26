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
@synthesize title;
@synthesize favoritedCount, viewCount;

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

#pragma mark -
#pragma mark Private Methods

- (void) loadJSON:(NSDictionary *)jsonDictionary {
	[super loadJSON:jsonDictionary];
	
	if ([jsonDictionary objectForKey:@"title"] != nil) {
		title = [[jsonDictionary objectForKey:@"title"] copy];
	}
	
	if ([jsonDictionary objectForKey:@"FavCount"] != nil) {
		favoritedCount = [[jsonDictionary objectForKey:@"FavCount"] unsignedIntegerValue];
	}
	
	if ([jsonDictionary objectForKey:@"ViewCount"] != nil) {
		viewCount = [[jsonDictionary objectForKey:@"ViewCount"] unsignedIntegerValue];
	}
}

@end
