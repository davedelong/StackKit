// 
//  SKComment.m
//  StackKit
//
//  Created by Dave DeLong on 1/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SKComment.h"
#import "SKObject+Private.h"
#import "SKQAPost.h"
#import "SKUser.h"
#import "SKConstants_Internal.h"

NSString * const SKCommentCreationDate = __SKPostCreationDate;
NSString * const SKCommentOwner = __SKPostOwner;
NSString * const SKCommentBody = __SKPostBody;
NSString * const SKCommentScore = __SKPostScore;

NSString * const SKCommentID = @"comment_id";
NSString * const SKCommentInReplyToUser = @"reply_to_user";
NSString * const SKCommentPost = @"post_id";
NSString * const SKCommentEditCount = @"edit_count";

NSString * const SKCommentPostType = @"post_type";

@implementation SKComment 

@dynamic editCount;
@dynamic post;
@dynamic directedToUser;

+ (NSString *) apiResponseDataKey {
	return @"comments";
}

+ (NSString *) apiResponseUniqueIDKey {
	return SKCommentID;
}

+ (NSDictionary *) APIAttributeToPropertyMapping {
    static NSDictionary *mapping = nil;
    if (!mapping) {
        mapping = [[super APIAttributeToPropertyMapping] mutableCopy];
        [(NSMutableDictionary *)mapping addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                  @"postID", SKCommentID,
                                                                  @"editCount", SKCommentEditCount,
                                                                  @"post", SKCommentPost,
                                                                  @"directedToUser", SKCommentInReplyToUser,
                                                                  nil]];
    }
    return mapping;
}

@end
