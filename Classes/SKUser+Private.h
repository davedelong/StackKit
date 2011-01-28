//
//  SKUser+Private.h
//  StackKit
//
//  Created by Dave DeLong on 1/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKUser.h"

@interface SKUser (Private)

@property (nonatomic, retain) NSNumber * downVotes;
@property (nonatomic, retain) NSDate * lastAccessDate;
@property (nonatomic, retain) NSNumber * userID;
@property (nonatomic, retain) NSNumber * upVotes;
@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSNumber * userType;
@property (nonatomic, retain) id websiteURL;
@property (nonatomic, retain) NSString * displayName;
@property (nonatomic, retain) NSString * aboutMe;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSNumber * reputation;
@property (nonatomic, retain) NSNumber * acceptRate;
@property (nonatomic, retain) NSString * emailHash;
@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSNumber * views;
@property (nonatomic, retain) NSSet* posts;
@property (nonatomic, retain) NSSet* badges;
@property (nonatomic, retain) NSSet* directedComments;

@end



@interface SKUser (CoreDataGeneratedAccessors)
- (void)addPostsObject:(SKPost *)value;
- (void)removePostsObject:(SKPost *)value;
- (void)addPosts:(NSSet *)value;
- (void)removePosts:(NSSet *)value;

- (void)addBadgesObject:(SKBadge *)value;
- (void)removeBadgesObject:(SKBadge *)value;
- (void)addBadges:(NSSet *)value;
- (void)removeBadges:(NSSet *)value;

- (void)addDirectedCommentsObject:(SKComment *)value;
- (void)removeDirectedCommentsObject:(SKComment *)value;
- (void)addDirectedComments:(NSSet *)value;
- (void)removeDirectedComments:(NSSet *)value;

@end