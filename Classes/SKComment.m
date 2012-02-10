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

@dynamic commentID;
@dynamic creationDate;
@dynamic score;
@dynamic edited;
@dynamic body;
@dynamic ownerID;
@dynamic inReplyToUserID;
@dynamic postID;
@dynamic postType;

+ (NSString *)_uniquelyIdentifyingAPIKey {
    return SKAPIKeys.comment.commentID;
}

+ (NSArray *)APIKeysBackingProperties {
    static dispatch_once_t onceToken;
    static NSArray *keys = nil;
    dispatch_once(&onceToken, ^{
        keys = [[NSArray alloc] initWithObjects:
                SKAPIKeys.comment.commentID,
                SKAPIKeys.comment.creationDate,
                SKAPIKeys.comment.score,
                SKAPIKeys.comment.edited,
                SKAPIKeys.comment.body,
                SKAPIKeys.comment.postID,
                SKAPIKeys.comment.postType,
                @"owner_id",
                @"in_reply_to_user_id",
                nil];
    });
    return keys;
}

+ (NSDictionary *)_mutateResponseDictionary:(NSDictionary *)d {
    NSDictionary *owner = [d objectForKey:SKAPIKeys.comment.owner];
    NSDictionary *reply = [d objectForKey:SKAPIKeys.comment.replyToUser];
    if (owner || reply) {
        NSMutableDictionary *md = [d mutableCopy];
        
        id userID = [owner objectForKey:SKAPIKeys.user.userID];
        if (userID) {
            [md setObject:userID forKey:@"owner_id"];
        }
        
        id replyID = [reply objectForKey:SKAPIKeys.user.userID];
        if (replyID) {
            [md setObject:replyID forKey:@"in_reply_to_user_id"];
        }
        
        d = [md autorelease];
    }
    return d;
}

- (SKPostType)postType {
    NSString *type = [self _valueForInfoKey:SKAPIKeys.comment.postType];
    if ([type isEqualToString:@"question"]) {
        return SKPostTypeQuestion;
    }
    return SKPostTypeAnswer;
}

@end
