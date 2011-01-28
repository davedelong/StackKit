//
//  SKUser.h
//  StackKit
//
//  Created by Dave DeLong on 1/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "SKObject.h"

@class SKBadge;
@class SKComment;
@class SKPost;

@interface SKUser :  SKObject {
	
}

@property (nonatomic, retain, readonly) NSNumber * downVotes;
@property (nonatomic, retain, readonly) NSDate * lastAccessDate;
@property (nonatomic, retain, readonly) NSNumber * userID;
@property (nonatomic, retain, readonly) NSNumber * upVotes;
@property (nonatomic, retain, readonly) NSNumber * age;
@property (nonatomic, retain, readonly) NSNumber * userType;
@property (nonatomic, retain, readonly) id websiteURL;
@property (nonatomic, retain, readonly) NSString * displayName;
@property (nonatomic, retain, readonly) NSString * aboutMe;
@property (nonatomic, retain, readonly) NSString * location;
@property (nonatomic, retain, readonly) NSNumber * reputation;
@property (nonatomic, retain, readonly) NSNumber * acceptRate;
@property (nonatomic, retain, readonly) NSString * emailHash;
@property (nonatomic, retain, readonly) NSDate * creationDate;
@property (nonatomic, retain, readonly) NSNumber * views;
@property (nonatomic, retain, readonly) NSSet* posts;
@property (nonatomic, retain, readonly) NSSet* badges;
@property (nonatomic, retain, readonly) NSSet* directedComments;

@end

