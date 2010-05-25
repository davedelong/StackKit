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

+ (id) stackoverflowSite {
	NSString * key = [NSString stringWithContentsOfFile:@"consumerKey.txt" encoding:NSUTF8StringEncoding error:nil];
	if (key == nil) { return nil; }
	return [[[self alloc] initWithAPIURL:[NSURL URLWithString:@"http://api.stackoverflow.com"] APIKey:key] autorelease];
}

#pragma mark -
#pragma mark Init/Dealloc

- (id) initWithAPIURL:(NSURL *)aURL APIKey:(NSString*)key {
	if (self = [super initWithSite:nil]) {
		apiURL = [[aURL URLByAppendingPathComponent:SKAPIVersion] retain];
		apiKey = [key copy];
		
		cachedPosts = [[NSMutableDictionary alloc] init];
		cachedUsers = [[NSMutableDictionary alloc] init];
		cachedTags = [[NSMutableDictionary alloc] init];
		cachedBadges = [[NSMutableDictionary alloc] init];
		
		timeoutInterval = 60.0;
		requestQueue = [[NSOperationQueue alloc] init];
		[requestQueue setMaxConcurrentOperationCount:1];
	}
	return self;
}

- (void) dealloc {
	[apiURL release];
	[apiKey release];
	
	[cachedPosts release];
	[cachedUsers release];
	[cachedTags release];
	[cachedBadges release];
	
	[requestQueue cancelAllOperations];
	[requestQueue release];
	
	[super dealloc];
}

#pragma mark -
#pragma mark Accessors

- (SKSite *) site {
	return [[self retain] autorelease];
}

/**
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
	[cachedBadges setObject:newBadge forKey:[newBadge ID]];
}
**/

#pragma mark -
#pragma mark Fetch Requests

- (SKUser *) userWithID:(NSNumber *)aUserID {
	SKFetchRequest * request = [[SKFetchRequest alloc] init];
	[request setEntity:[SKUser class]];
	[request setPredicate:[NSPredicate predicateWithFormat:@"%K = %@", SKUserID, aUserID]];
	NSError * error = nil;
	NSArray * matches = [self executeSynchronousFetchRequest:request error:&error];
	[request release];
	if (error != nil) { return nil; }
	if ([matches count] != 1) { return nil; }
	return [matches objectAtIndex:0];
}

- (NSArray *) executeSynchronousFetchRequest:(SKFetchRequest *)fetchRequest error:(NSError **)error {
	[fetchRequest setSite:self];
	[fetchRequest setDelegate:nil];
	
	NSArray * results = [fetchRequest execute];
	if ([fetchRequest error] && error) {
		*error = [fetchRequest error];
	}
	return results;
}

- (void) executeFetchRequest:(SKFetchRequest *)fetchRequest {
	if ([fetchRequest delegate] == nil) {
		@throw [NSException exceptionWithName:SKExceptionInvalidDelegate reason:@"SKFetchRequest.delegate cannot be nil" userInfo:nil];
	}
	if ([[fetchRequest delegate] conformsToProtocol:@protocol(SKFetchRequestDelegate)] == NO) {
		@throw [NSException exceptionWithName:SKExceptionInvalidDelegate reason:@"SKFetchRequest.delegate must conform to <SKFetchRequestDelegate>" userInfo:nil];
	}
	
	NSInvocationOperation * operation = [[NSInvocationOperation alloc] initWithTarget:fetchRequest selector:@selector(executeAsynchronously) object:nil];
	[requestQueue addOperation:operation];
	[operation release];
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
	
	return [[statistics objectForKey:@"statistics"] objectAtIndex:0];
}

@end
