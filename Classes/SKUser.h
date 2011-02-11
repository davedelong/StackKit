//
//  SKUser.h
//  StackKit
//
//  Created by Dave DeLong on 1/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "SKObject.h"

@interface SKUser : SKObject  
{
}

@property (nonatomic, readonly) NSString * aboutMe;
@property (nonatomic, readonly) NSNumber * acceptRate;
@property (nonatomic, readonly) NSNumber * age;
@property (nonatomic, readonly) NSString * associationID;
@property (nonatomic, readonly) NSDate * creationDate;
@property (nonatomic, readonly) NSString * displayName;
@property (nonatomic, readonly) NSNumber * downVotes;
@property (nonatomic, readonly) NSString * emailHash;
@property (nonatomic, readonly) NSDate * lastAccessDate;
@property (nonatomic, readonly) NSString * location;
@property (nonatomic, readonly) NSNumber * reputation;
@property (nonatomic, readonly) NSNumber * upVotes;
@property (nonatomic, readonly) NSNumber * userID;
@property (nonatomic, readonly) NSNumber * userType;
@property (nonatomic, readonly) NSNumber * viewCount;
@property (nonatomic, readonly) NSURL * websiteURL;

@property (nonatomic, readonly) NSSet * awardedBadges;
@property (nonatomic, readonly) NSSet * directedComments;
@property (nonatomic, readonly) NSSet * posts;

@property (nonatomic, readonly) NSURL * gravatarIconURL;

- (NSURL *) gravatarIconURLForSize:(CGSize)size;

@end

