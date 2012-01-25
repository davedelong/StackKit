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
@class SKUser;

@interface SKFetchRequest : NSObject

+ (SKUserFetchRequest *)requestForFetchingUsers;
+ (SKTagFetchRequest *)requestForFetchingTags;
+ (SKBadgeFetchRequest *)requestForFetchingBadges;

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

- (id)onlyTagBased;
- (id)onlyNonTagBased;

- (id)withIDs:(NSUInteger)badgeID, ... NS_REQUIRES_NIL_TERMINATION;

- (id)usedByUsers:(SKUser *)user, ... NS_REQUIRES_NIL_TERMINATION;
- (id)usedByUsersWithIDs:(NSUInteger)userID, ... NS_REQUIRES_NIL_TERMINATION;

@end
