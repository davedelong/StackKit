//
//  SKComment.h
//  StackKit
//
//  Created by Dave DeLong on 1/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "SKPost.h"

//inherited
extern NSString * const SKCommentCreationDate;
extern NSString * const SKCommentOwner;
extern NSString * const SKCommentBody;
extern NSString * const SKCommentScore;

extern NSString * const SKCommentID;
extern NSString * const SKCommentInReplyToUser;
extern NSString * const SKCommentPost;
extern NSString * const SKCommentEditCount;

@class SKQAPost;
@class SKUser;

@interface SKComment :  SKPost  
{
}

@property (nonatomic, readonly) NSNumber * commentID;
@property (nonatomic, readonly) NSNumber * editCount;
@property (nonatomic, readonly) SKQAPost * post;
@property (nonatomic, readonly) SKUser * directedToUser;

@end



