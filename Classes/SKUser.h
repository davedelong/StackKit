//
//  SKUser.h
//  StackKit
//
//  Created by Dave DeLong on 1/25/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKObject.h"

@class SKSite;

@interface SKUser : SKObject {
	
	BOOL _flairLoaded;
	NSString * userID;
	NSString * displayName;
	NSURL * profileURL;
	NSUInteger reputation;
	
	BOOL _favoritesLoaded;
	NSMutableSet * favorites;
	
	BOOL _badgesLoaded;
	NSMutableSet * badges;
}

@property (readonly) NSString * userID;
@property (readonly) NSString * displayName;
@property (readonly) NSURL * profileURL;
@property (readonly) NSUInteger reputation;

@property (readonly) NSSet * favorites;
@property (readonly) NSSet * badges;

+ (id)userWithSite:(SKSite*)aSite userID:(NSString*)anID;

@end
