//
//  SKUser.h
//  StackKit
/**
  Copyright (c) 2011 Dave DeLong
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 **/

#import <Foundation/Foundation.h>
#import "SKObject.h"

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

typedef enum {
	SKUserTypeAnonymous = 0,
	SKUserTypeUnregistered = 1,
	SKUserTypeRegistered = 2,
	SKUserTypeModerator = 3
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

- (NSURL *) gravatarIconURL;
- (NSURL *) gravatarIconURLForSize:(CGSize)size;

@end
