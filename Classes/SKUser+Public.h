//
//  SKUser+Public.h
//  StackKit
//
//  Created by Dave DeLong on 1/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKUser.h"

extern NSString * const SKUserID;

extern NSString * const SKUserReputation;
extern NSString * const SKUserCreationDate;
extern NSString * const SKUserDisplayName;
extern NSString * const SKUserEmailHash;
extern NSString * const SKUserAge;
extern NSString * const SKUserLastAccessDate;
extern NSString * const SKUserWebsiteURL;
extern NSString * const SKUserLocation;
extern NSString * const SKUserAboutMe;
extern NSString * const SKUserViews;
extern NSString * const SKUserUpVotes;
extern NSString * const SKUserDownVotes;
extern NSString * const SKUserType;
extern NSString * const SKUserAcceptRate;

extern NSString * const SKUserBadges;


@interface SKUser (Public)

- (NSURL *) gravatarIconURL;
- (NSURL *) gravatarIconURLForSize:(CGSize)size;

@end
