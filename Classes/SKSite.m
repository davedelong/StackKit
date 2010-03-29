//
//  SKSite.m
//  StackKit
//
//  Created by Dave DeLong on 1/25/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "StackKit_Internal.h"

NSString * SKSiteAPIKey = @"key";

@implementation SKSite

@synthesize apiKey;
@synthesize apiURL;
@synthesize cachedPosts, cachedUsers, cachedTags;
@synthesize timeoutInterval;

- (id) initWithAPIURL:(NSURL *)aURL APIKey:(NSString*)key {
	if (self = [super initWithSite:nil]) {
		apiURL = [aURL retain];
		apiKey = [key copy];
		
		cachedPosts = [[NSMutableDictionary alloc] init];
		cachedUsers = [[NSMutableDictionary alloc] init];
		cachedTags = [[NSMutableDictionary alloc] init];
		
		timeoutInterval = 60.0;
	}
	return self;
}

- (void) dealloc {
	[apiURL release];
	
	[cachedPosts release];
	[cachedUsers release];
	[cachedTags release];
	
	[super dealloc];
}

- (SKSite *) site {
	return [[self retain] autorelease];
}

- (void) cacheUser:(SKUser *)newUser {
	[cachedUsers setObject:newUser forKey:[newUser userID]];
}

- (void) cacheTag:(SKTag *)newTag {
	[cachedTags setObject:newTag forKey:[newTag name]];
}

- (void) cachePost:(SKPost *)newPost {
	[cachedPosts setObject:newPost forKey:[newPost postID]];
}

- (SKUser *) userWithID:(NSString *)aUserID {
	return [SKUser userWithSite:self userID:aUserID];
}

@end
