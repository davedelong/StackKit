//
//  SKComment.h
//  StackKit
//
//  Created by Dave DeLong on 1/25/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKPost.h"

extern NSString * const SKCommentID;
extern NSString * const SKCommentInReplyToUser;
extern NSString * const SKCommentPost;
extern NSString * const SKCommentScore;
extern NSString * const SKCommentEditCount;

@class SKPost;
@class SKUser;

@interface SKComment : SKPost {
	NSNumber * commentID;
	NSNumber * replyToUserID;
	NSNumber * postID;
	SKPostType_t postType;
	NSNumber * score;
	NSNumber * editCount;
}

@property (readonly) NSNumber * commentID;
@property (readonly) NSNumber * replyToUserID;
@property (readonly) NSNumber * postID;
@property (readonly) NSNumber * score;
@property (readonly) NSNumber * editCount;

- (SKUser *) replyToUser;
- (SKPost *) post;

@end
