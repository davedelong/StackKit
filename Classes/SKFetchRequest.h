//
//  SKFetchRequest.h
//  StackKit
//
//  Created by Dave DeLong on 12/31/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SKUserFetchRequest;
@class SKTagFetchRequest;
@class SKBadgeFetchRequest;
@class SKAnswerFetchRequest;
@class SKCommentFetchRequest;

@class SKUser;
@class SKTag;

@interface SKFetchRequest : NSObject

+ (SKUserFetchRequest *)requestForFetchingUsers;
+ (SKTagFetchRequest *)requestForFetchingTags;
+ (SKBadgeFetchRequest *)requestForFetchingBadges;
+ (SKAnswerFetchRequest *)requestForFetchingAnswers;
+ (SKCommentFetchRequest *)requestForFetchingComments;

- (id)inAscendingOrder;
- (id)inDescendingOrder;

@end

@interface SKUserFetchRequest : SKFetchRequest

- (id)createdAfter:(NSDate *)date;
- (id)createdBefore:(NSDate *)date;

- (id)sortedByCreationDate;
- (id)sortedByName;
- (id)sortedByReputation;
- (id)sortedByLastModifiedDate;

- (id)whoseDisplayNameContains:(NSString *)name;
- (id)withIDs:(NSUInteger)userID,... NS_REQUIRES_NIL_TERMINATION;

@end

@interface SKTagFetchRequest : SKFetchRequest

- (id)whoseNameContains:(NSString *)name;

- (id)sortedByPopularity;
- (id)sortedByLastUsedDate;
- (id)sortedByName;

- (id)usedOnQuestionsCreatedAfter:(NSDate *)date;
- (id)usedOnQuestionsCreatedBefore:(NSDate *)date;

- (id)usedByUsers:(SKUser *)user, ... NS_REQUIRES_NIL_TERMINATION;
- (id)usedByUsersWithIDs:(NSUInteger)userID, ... NS_REQUIRES_NIL_TERMINATION;

@end

@interface SKBadgeFetchRequest : SKFetchRequest

- (id)sortedByRank;
- (id)sortedByName;
- (id)sortedByTagBased;

- (id)tagBasedOnly;
- (id)namedOnly;

- (id)whoseNameContains:(NSString *)name;

- (id)withIDs:(NSUInteger)badgeID, ... NS_REQUIRES_NIL_TERMINATION;

- (id)usedByUsers:(SKUser *)user, ... NS_REQUIRES_NIL_TERMINATION;
- (id)usedByUsersWithIDs:(NSUInteger)userID, ... NS_REQUIRES_NIL_TERMINATION;

@end

@interface SKAnswerFetchRequest : SKFetchRequest

- (id)sortedByCreationDate;
- (id)sortedByScore;
- (id)sortedByLastActivityDate;

- (id)withIDs:(NSUInteger)answerID, ... NS_REQUIRES_NIL_TERMINATION;

- (id)postedinTags:(SKTag *)tag, ... NS_REQUIRES_NIL_TERMINATION;
- (id)postedinTagsWithNames:(NSString *)tag, ... NS_REQUIRES_NIL_TERMINATION;

- (id)postedByUsers:(SKUser *)user, ... NS_REQUIRES_NIL_TERMINATION;
- (id)postedByUsersWithIDs:(NSUInteger)userID, ... NS_REQUIRES_NIL_TERMINATION;

//- (id)postedOnQuestions:(SKQuestion *)question, ... NS_REQUIRES_NIL_TERMINATION;
//- (id)postedOnQuestionsWithIDs:(NSUInteger)questionID, ... NS_REQUIRES_NIL_TERMINATION;

@end

@interface SKCommentFetchRequest : SKFetchRequest

- (id)sortedByCreationDate;
- (id)sortedByScore;

- (id)withIDs:(NSUInteger)commentID, ... NS_REQUIRES_NIL_TERMINATION;

- (id)postedOnPostsWithIDs:(NSUInteger)postID, ... NS_REQUIRES_NIL_TERMINATION;

- (id)postedByUsers:(SKUser *)user, ... NS_REQUIRES_NIL_TERMINATION;
- (id)postedByUsersWithIDs:(NSUInteger)userID, ... NS_REQUIRES_NIL_TERMINATION;

- (id)mentioningUsers:(SKUser *)user, ... NS_REQUIRES_NIL_TERMINATION;
- (id)mentioningUsersWithIDs:(NSUInteger)userID, ... NS_REQUIRES_NIL_TERMINATION;

@end
