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
@synthesize cachedPosts, cachedUsers, cachedTags, cachedBadges;
@synthesize timeoutInterval;

#pragma mark -
#pragma mark Init/Dealloc

- (id) initWithAPIURL:(NSURL *)aURL {
	return [self initWithAPIURL:aURL APIKey:SKAPIKey];
}

- (id) initWithAPIURL:(NSURL *)aURL APIKey:(NSString*)key {
	if (self = [super initWithSite:nil]) {
		apiURL = [[aURL URLByAppendingPathComponent:SKAPIVersion] retain];
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
	[apiKey release];
	
	[cachedPosts release];
	[cachedUsers release];
	[cachedTags release];
	
	[super dealloc];
}

#pragma mark -
#pragma mark Accessors

- (SKSite *) site {
	return [[self retain] autorelease];
}

#pragma mark -
#pragma mark Object Caching

- (void) cacheUser:(SKUser *)newUser {
	[cachedUsers setObject:newUser forKey:[newUser userID]];
}

- (void) cacheTag:(SKTag *)newTag {
	[cachedTags setObject:newTag forKey:[newTag name]];
}

- (void) cachePost:(SKPost *)newPost {
	[cachedPosts setObject:newPost forKey:[newPost postID]];
}

- (void) cacheBadge:(SKBadge *)newBadge {
	[cachedBadges setObject:newBadge forKey:[newBadge badgeID]];
}

#pragma mark -
#pragma mark Fetch Requests

- (SKUser *) userWithID:(NSNumber *)aUserID {
	SKFetchRequest * request = [[SKFetchRequest alloc] init];
	[request setEntity:[SKUser class]];
	[request setPredicate:[NSPredicate predicateWithFormat:@"%K = %@", SKUserID, aUserID]];
	NSError * error = nil;
	NSArray * matches = [self executeFetchRequest:request error:&error];
	[request release];
	if (error != nil) { return nil; }
	if ([matches count] != 1) { return nil; }
	return [matches objectAtIndex:0];
}

- (NSArray *) executeFetchRequest:(SKFetchRequest *)fetchRequest error:(NSError **)error {
	[fetchRequest setSite:self];
	NSArray * results = [fetchRequest executeWithError:error];
	return results;
}

- (NSDictionary *) statistics {
	NSDictionary * queryDictionary = [NSDictionary dictionaryWithObject:[self apiKey] forKey:SKSiteAPIKey];
	NSString * statsPath = [NSString stringWithFormat:@"stats?%@", [queryDictionary queryString]];
	
	NSString * statsCall = [[[self apiURL] absoluteString] stringByAppendingPathComponent:statsPath];
	
	NSURL * statsURL = [NSURL URLWithString:statsCall];
	
	NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[statsURL absoluteURL]];
	NSURLResponse * response = nil;
	
	NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:nil];
	NSString * responseString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
	
	NSDictionary * statistics = [responseString JSONValue];
	
	assert([statistics isKindOfClass:[NSDictionary class]]);
	assert([[statistics allKeys] count] == 1);
	
	NSLog(@"%@", statistics);
	
	return [[statistics objectForKey:@"statistics"] objectAtIndex:0];
}

@end
