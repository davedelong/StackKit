//
//  SKComment.m
//  StackKit
//
//  Created by Dave DeLong on 2/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SKComment.h"
#import <StackKit/SKConstants.h>
#import <StackKit/SKObject_Internal.h>

@implementation SKComment

@dynamic creationDate;
@dynamic score;
@dynamic edited;
@dynamic body;
@dynamic ownerID;
@dynamic inReplyToUserID;
@dynamic postID;
@dynamic parentPostID;

+ (NSString *)_uniquelyIdentifyingAPIKey {
    return SKAPIKeys.comment.commentID;
}

+ (NSArray *)APIKeysBackingProperties {
    static dispatch_once_t onceToken;
    static NSArray *keys = nil;
    dispatch_once(&onceToken, ^{
        keys = [[NSArray alloc] initWithObjects:
                // SKPost attributes
                SKAPIKeys.post.creationDate,
                SKAPIKeys.post.score,
                SKAPIKeys.post.body,
                
                SKAPIKeys.post.postID,
                SKAPIKeys.post.ownerID,
                
                // SKChildPost attributes
                SKAPIKeys.childPost.parentPostID,
                SKAPIKeys.childPost.parentPostType,
                
                // SKComment attributes
                SKAPIKeys.comment.edited,
                @"in_reply_to_user_id",
                nil];
    });
    return keys;
}

+ (NSDictionary *)_mutateResponseDictionary:(NSDictionary *)d {
    NSMutableDictionary *md = [d mutableCopy];
    [md setObject:[md objectForKey:SKAPIKeys.comment.commentID] forKey:SKAPIKeys.post.postID];
    
    NSDictionary *owner = [d objectForKey:SKAPIKeys.question.owner];
    if (owner) {
        id userID = [owner objectForKey:SKAPIKeys.user.userID];
        if (userID) {
            [md setObject:userID forKey:SKAPIKeys.post.ownerID];
        }
    }
    
    NSDictionary *reply = [md objectForKey:SKAPIKeys.comment.replyToUser];
    if (reply) {
        id userID = [reply objectForKey:SKAPIKeys.user.userID];
        if (userID) {
            [md setObject:userID forKey:@"in_reply_to_user_id"];
        }
    }
    
    id parentID = [md objectForKey:SKAPIKeys.comment.postID];
    [md setObject:parentID forKey:SKAPIKeys.childPost.parentPostID];
    
    id parentType = [md objectForKey:SKAPIKeys.comment.postType];
    [md setObject:parentType forKey:SKAPIKeys.childPost.parentPostType];
    
    return [md autorelease];
}

- (SKPostType)postType {
    return SKPostTypeComment;
}

- (SKPostType)parentPostType {
    NSString *type = [self _valueForInfoKey:SKAPIKeys.childPost.parentPostType];
    if ([type isEqualToString:@"question"]) {
        return SKPostTypeQuestion;
    }
    return SKPostTypeAnswer;
}

@end
