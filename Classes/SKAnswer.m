//
//  SKAnswer.m
//  StackKit
//
//  Created by Dave DeLong on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SKAnswer.h"
#import <StackKit/SKConstants.h>
#import <StackKit/SKObject_Internal.h>

@implementation SKAnswer
@dynamic postID;
@dynamic ownerID;
@dynamic parentPostID;

@dynamic title;
@dynamic body;
@dynamic isAccepted;

@dynamic score;
@dynamic upVoteCount;
@dynamic downVoteCount;

@dynamic creationDate;
@dynamic lockedDate;
@dynamic lastEditDate;
@dynamic lastActivityDate;
@dynamic communityOwnedDate;

+ (NSString *)_uniquelyIdentifyingAPIKey {
    return SKAPIKeys.answer.answerID;
}

+ (NSArray *)APIKeysBackingProperties {
    static dispatch_once_t onceToken;
    static NSArray *keys = nil;
    dispatch_once(&onceToken, ^{
        keys = [[NSArray alloc] initWithObjects:
                SKAPIKeys.post.postID,
                SKAPIKeys.post.body,
                SKAPIKeys.post.ownerID,
                SKAPIKeys.post.score,
                SKAPIKeys.post.creationDate,
                
                SKAPIKeys.answer.title,
                SKAPIKeys.answer.isAccepted,
                SKAPIKeys.answer.upVoteCount,
                SKAPIKeys.answer.downVoteCount,
                SKAPIKeys.answer.lockedDate,
                SKAPIKeys.answer.lastEditDate,
                SKAPIKeys.answer.lastActivityDate,
                SKAPIKeys.answer.communityOwnedDate,
                
                SKAPIKeys.childPost.parentPostID,
                nil];
    });
    return keys;
}

+ (NSDictionary *)_mutateResponseDictionary:(NSDictionary *)d {
    NSMutableDictionary *md = [d mutableCopy];
    
    id answerID = [md objectForKey:SKAPIKeys.answer.answerID];
    [md setObject:answerID forKey:SKAPIKeys.post.postID];
    
    id questionID = [md objectForKey:SKAPIKeys.answer.questionID];
    [md setObject:questionID forKey:SKAPIKeys.childPost.parentPostID];
    
    NSDictionary *owner = [d objectForKey:SKAPIKeys.answer.owner];
    if (owner) {
        id userID = [owner objectForKey:SKAPIKeys.user.userID];
        [md setObject:userID forKey:SKAPIKeys.post.ownerID];
    }
    
    return [md autorelease];
}

- (SKPostType)postType {
    return SKPostTypeAnswer;
}

- (SKPostType)parentPostType {
    return SKPostTypeQuestion;
}

@end
