//
//  SKSite.h
//  StackKit
//
//  Created by Dave DeLong on 1/25/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKObject.h"

extern NSString * SKSiteAPIKey;

@class SKUser;
@class SKFetchRequest;

@interface SKSite : SKObject {
	NSString * apiKey;
	NSURL * apiURL;
	
	NSMutableDictionary * cachedPosts;
	NSMutableDictionary * cachedUsers;
	NSMutableDictionary * cachedTags;
	NSMutableDictionary * cachedBadges;
	
	NSTimeInterval timeoutInterval;
	
	NSOperationQueue * requestQueue;
}

@property (readonly) NSURL * apiURL;

@property (readonly) NSDictionary * cachedUsers;
@property (readonly) NSDictionary * cachedPosts;
@property (readonly) NSDictionary * cachedTags;
@property (readonly) NSDictionary * cachedBadges;
@property (readonly) NSString * apiKey;

@property NSTimeInterval timeoutInterval;

+ (id) stackoverflowSite;

- (id) initWithAPIURL:(NSURL *)aURL APIKey:(NSString*)key;

- (SKUser *) userWithID:(NSNumber *)aUserID;

- (NSArray *) executeSynchronousFetchRequest:(SKFetchRequest *)fetchRequest error:(NSError **)error;
- (void) executeFetchRequestAsynchronously:(SKFetchRequest *)fetchRequest;

- (NSDictionary *) statistics;

@end
