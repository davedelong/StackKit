//
//  SKUser.h
//  StackKit
//
//  Created by Dave DeLong on 1/25/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKObject.h"

extern NSString * const SKUserID;

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
extern NSString * SKUserType;
extern NSString * SKUserAcceptRate;

typedef enum {
	SKUserTypeRegistered = 0,
	SKUserTypeModerator = 1
} SKUserType_t;

@class SKSite;

@interface SKUser : SKObject {
	
	NSNumber * userID;
	NSNumber * reputation;
	NSDate * creationDate;
	NSString * displayName;
	NSString * emailHash;
	NSNumber * age;
	NSDate * lastAccessDate;
	NSURL * websiteURL;
	NSString * location;
	NSString * aboutMe;
	NSNumber * views;
	NSNumber * upVotes;
	NSNumber * downVotes;
	SKUserType_t userType;
	NSNumber * acceptRate;
}

@property (readonly) NSNumber * userID;
@property (readonly) NSNumber * reputation;
@property (readonly) NSDate * creationDate;
@property (readonly) NSString * displayName;
@property (readonly) NSString * emailHash;
@property (readonly) NSNumber * age;
@property (readonly) NSDate * lastAccessDate;
@property (readonly) NSURL * websiteURL;
@property (readonly) NSString * location;
@property (readonly) NSString * aboutMe;
@property (readonly) NSNumber * views;
@property (readonly) NSNumber * upVotes;
@property (readonly) NSNumber * downVotes;
@property (readonly) SKUserType_t userType;
@property (readonly) NSNumber * acceptRate;

- (NSArray *) badges;
- (NSArray *) tags;

@end
