//
//  SKUser.h
//  StackKit
//
//  Created by Dave DeLong on 1/25/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKObject.h"

extern NSString * SKUserID;
extern NSString * SKUserReputation;
extern NSString * SKUserCreationDate;
extern NSString * SKUserDisplayName;
extern NSString * SKUserEmailHash;
extern NSString * SKUserAge;
extern NSString * SKUserLastAccessDate;
extern NSString * SKUserWebsiteURL;
extern NSString * SKUserLocation;
extern NSString * SKUserAboutMe;
extern NSString * SKUserViews;
extern NSString * SKUserUpVotes;
extern NSString * SKUserDownVotes;
extern NSString * SKUserIsModerator;
extern NSString * SKUserAcceptRate;

@class SKSite;

@interface SKUser : SKObject {
	
	NSNumber * userID;
	NSUInteger reputation;
	NSDate * creationDate;
	NSString * displayName;
	NSString * emailHash;
	NSUInteger age;
	NSDate * lastAccessDate;
	NSURL * websiteURL;
	NSString * location;
	NSString * aboutMe;
	NSUInteger views;
	NSUInteger upVotes;
	NSUInteger downVotes;
	BOOL moderator;
	float acceptRate;
}

@property (readonly) NSNumber * userID;
@property (readonly) NSUInteger reputation;
@property (readonly) NSDate * creationDate;
@property (readonly) NSString * displayName;
@property (readonly) NSString * emailHash;
@property (readonly) NSUInteger age;
@property (readonly) NSDate * lastAccessDate;
@property (readonly) NSURL * websiteURL;
@property (readonly) NSString * location;
@property (readonly) NSString * aboutMe;
@property (readonly) NSUInteger views;
@property (readonly) NSUInteger upVotes;
@property (readonly) NSUInteger downVotes;
@property (readonly, getter=isModerator) BOOL moderator;
@property (readonly) float acceptRate;

@end
