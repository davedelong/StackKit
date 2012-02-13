//
//  SKCommentFetchRequest.m
//  StackKit
//
//  Created by Dave DeLong on 2/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SKCommentFetchRequest.h"
#import <StackKit/SKFunctions.h>
#import <StackKit/SKConstants.h>
#import <StackKit/SKComment.h>
#import <StackKit/SKUser.h>
#import <StackKit/SKMacros.h>

@implementation SKCommentFetchRequest

@synthesize commentIDs=_commentIDs;
@synthesize postIDs=_postIDs;
@synthesize userIDs=_userIDs;
@synthesize replyIDs=_replyIDs;

+ (Class)_targetClass { return [SKComment class]; }

- (id)init {
    self = [super init];
    if (self) {
        _commentIDs = [[NSMutableIndexSet alloc] init];
        _postIDs = [[NSMutableIndexSet alloc] init];
        _userIDs = [[NSMutableIndexSet alloc] init];
        _replyIDs = [[NSMutableIndexSet alloc] init];
    }
    return self;
}

- (void)dealloc {
    [_commentIDs release];
    [_postIDs release];
    [_userIDs release];
    [_replyIDs release];
    [super dealloc];
}

- (id)sortedByCreationDate {
    [self setSortKey:SKSortValues.comment.creationDate];
    return self;
}

- (id)sortedByScore {
    [self setSortKey:SKSortValues.comment.score];
    return self;
}

- (id)withIDs:(NSUInteger)commentID, ... {
    INTEGER_LIST(_commentIDs, commentID);
    return self;    
}

- (id)postedOnPostsWithIDs:(NSUInteger)postID, ... {
    INTEGER_LIST(_postIDs, postID);
    return self;  
}

- (id)postedByUsers:(SKUser *)user, ...  {
    OBJECT_LIST(_userIDs, user, userID);
    return self;
}

- (id)postedByUsersWithIDs:(NSUInteger)userID, ...  {
    INTEGER_LIST(_userIDs, userID);
    return self;
}

- (id)inReplyToUsers:(SKUser *)user, ... {
    OBJECT_LIST(_replyIDs, user, userID);
    return self;
}

- (id)inReplyToUsersWithIDs:(NSUInteger)userID, ... {
    INTEGER_LIST(_replyIDs, userID);
    return self;
}

- (NSString *)_path {
    if ([_commentIDs count] > 0) {
        return [NSString stringWithFormat:@"comments/%@", SKQueryString(_commentIDs)];
    }
    
    if ([_postIDs count] > 0) {
        return [NSString stringWithFormat:@"posts/%@/comments", SKQueryString(_commentIDs)];
    }
    
    if ([_userIDs count] > 0) {
        if ([_replyIDs count] > 0) {
            return [NSString stringWithFormat:@"users/%@/comments/%lu", SKQueryString(_userIDs), [_replyIDs firstIndex]];
        }
        
        return [NSString stringWithFormat:@"users/%@/comments", SKQueryString(_userIDs)];
    }
    
    if ([_replyIDs count] > 0) {
        return [NSString stringWithFormat:@"users/%@/mentioned", SKQueryString(_replyIDs)];
    }
    
    return @"comments";
}

- (NSMutableDictionary *)_queryDictionary {
    NSMutableDictionary *d = [super _queryDictionary];
    
    // I don't believe anything needs to be modified here
    
    return d;
}

@end
