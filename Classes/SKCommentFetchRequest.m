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
    if (commentID > 0) {
        [_commentIDs addIndex:commentID];
        va_list list;
        va_start(list, commentID);
        
        NSUInteger nextID = 0;
        while ((nextID = va_arg(list, NSUInteger)) != 0) {
            [_commentIDs addIndex:nextID];
        }
        
        va_end(list);
    }
    return self;    
}

- (id)postedOnPostsWithIDs:(NSUInteger)postID, ... {
    if (postID > 0) {
        [_postIDs addIndex:postID];
        va_list list;
        va_start(list, postID);
        
        NSUInteger nextID = 0;
        while ((nextID = va_arg(list, NSUInteger)) != 0) {
            [_postIDs addIndex:nextID];
        }
        
        va_end(list);
    }
    return self;  
}

- (id)postedByUsers:(SKUser *)user, ...  {
    if (user != nil) {
        [_userIDs addIndex:[user userID]];
        va_list list;
        va_start(list, user);
        
        while((user = va_arg(list, SKUser*)) != nil) {
            [_userIDs addIndex:[user userID]];
        }
        
        va_end(list);
    }
    return self;
}

- (id)postedByUsersWithIDs:(NSUInteger)userID, ...  {
    if (userID > 0) {
        [_userIDs addIndex:userID];
        va_list list;
        va_start(list, userID);
        
        NSUInteger nextID = 0;
        while ((nextID = va_arg(list, NSUInteger)) != 0) {
            [_userIDs addIndex:nextID];
        }
        
        va_end(list);
    }
    return self;
}

- (id)mentioningUsers:(SKUser *)user, ... {
    if (user != nil) {
        [_replyIDs addIndex:[user userID]];
        va_list list;
        va_start(list, user);
        
        while((user = va_arg(list, SKUser*)) != nil) {
            [_replyIDs addIndex:[user userID]];
        }
        
        va_end(list);
    }
    return self;
}

- (id)mentioningUsersWithIDs:(NSUInteger)userID, ... {
    if (userID > 0) {
        [_replyIDs addIndex:userID];
        va_list list;
        va_start(list, userID);
        
        NSUInteger nextID = 0;
        while ((nextID = va_arg(list, NSUInteger)) != 0) {
            [_replyIDs addIndex:nextID];
        }
        
        va_end(list);
    }
    return self;
}

- (NSString *)_path {
    if ([_commentIDs count] > 0) {
        return [NSString stringWithFormat:@"comments/%@", SKQueryString(_commentIDs)];
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
