//
//  SKSite.h
//  StackKit
//
//  Created by Dave DeLong on 1/25/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKObject.h"

@class SKUser;

@interface SKSite : SKObject {
	NSURL * siteURL;
	
	NSMutableDictionary * cachedPosts;
	NSMutableDictionary * cachedUsers;
	NSMutableDictionary * cachedTags;
}

@property (readonly) NSURL * siteURL;

@property (readonly) NSDictionary * cachedUsers;
@property (readonly) NSDictionary * cachedPosts;
@property (readonly) NSDictionary * cachedTags;

- (id) initWithURL:(NSURL *)aURL;

- (SKUser *) userWithID:(NSString *)aUserID;

@end
