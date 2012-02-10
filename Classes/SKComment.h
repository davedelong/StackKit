//
//  SKComment.h
//  StackKit
//
//  Created by Dave DeLong on 2/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <StackKit/SKObject.h>
#import <StackKit/SKTypes.h>

@interface SKComment : SKObject

@property (nonatomic, readonly) NSUInteger commentID;
@property (nonatomic, readonly) NSDate *creationDate;
@property (nonatomic, readonly) NSUInteger score;
@property (nonatomic, readonly) BOOL edited;
@property (nonatomic, readonly) NSString *body;

@property (nonatomic, readonly) NSUInteger ownerID;
@property (nonatomic, readonly) NSUInteger inReplyToUserID;

@property (nonatomic, readonly) NSUInteger postID;
@property (nonatomic, readonly) SKPostType postType;

@end
