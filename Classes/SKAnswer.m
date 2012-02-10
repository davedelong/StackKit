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

@dynamic answerID;
@dynamic questionID;
@dynamic ownerID;

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
                SKAPIKeys.answer.answerID,
                SKAPIKeys.answer.questionID,
                SKAPIKeys.answer.title,
                SKAPIKeys.answer.body,
                SKAPIKeys.answer.isAccepted,
                SKAPIKeys.answer.score,
                SKAPIKeys.answer.upVoteCount,
                SKAPIKeys.answer.downVoteCount,
                SKAPIKeys.answer.creationDate,
                SKAPIKeys.answer.lockedDate,
                SKAPIKeys.answer.lastEditDate,
                SKAPIKeys.answer.lastActivityDate,
                SKAPIKeys.answer.communityOwnedDate,
                @"owner_id",
                nil];
    });
    return keys;
}

+ (NSDictionary *)_mutateResponseDictionary:(NSDictionary *)d {
    NSDictionary *owner = [d objectForKey:SKAPIKeys.answer.owner];
    if (owner) {
        NSMutableDictionary *md = [d mutableCopy];
        id userID = [owner objectForKey:SKAPIKeys.user.userID];
        [md setObject:userID forKey:@"owner_id"];
        
        d = [md autorelease];
    }
    return d;
}

@end
