//
//  SKPost.m
//  StackKit
//
//  Created by Dave DeLong on 1/25/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "StackKit_Internal.h"

@implementation SKPost

@synthesize postID, creationDate, modifiedDate, author;

- (id) initWithSite:(SKSite *)aSite json:(NSDictionary *)json {
	NSNumber * anID = [json objectForKey:@"Id"];
	SKPost * p = [[aSite cachedPosts] objectForKey:anID];
	if (p != nil) {
		[self release];
		return [p retain];
	}
	
	if (self = [super initWithSite:aSite]) {
		postID = [anID copy];
		[self loadJSON:json];
	}
	[aSite cachePost:self];
	return self;
}

- (id) initWithSite:(SKSite *)aSite postID:(NSNumber *)anID {
	SKPost * p = [[aSite cachedPosts] objectForKey:anID];
	if (p != nil) {
		[self release];
		return [p retain];
	}
	
	if (self = [super initWithSite:aSite]) {
		postID = [anID copy];
	}
	
	[aSite cachePost:self];
	return self;
}

- (void) dealloc {
	[postID release];
	[super dealloc];
}

#pragma mark -
#pragma mark Private Methods

- (void) loadJSON:(NSDictionary *)jsonDictionary {
	if ([jsonDictionary objectForKey:@"CreatedDate"] != nil) {
		creationDate = [[NSDate dateWithJSONString:[jsonDictionary objectForKey:@"CreatedDate"]] retain];
	}
	if ([jsonDictionary objectForKey:@"LastEditDate"] != nil) {
		modifiedDate = [[NSDate dateWithJSONString:[jsonDictionary objectForKey:@"LastEditDate"]] retain];
	}
}

@end
