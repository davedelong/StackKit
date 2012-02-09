//
//  SKAnswer.h
//  StackKit
//
//  Created by Dave DeLong on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <StackKit/SKObject.h>

@interface SKAnswer : SKObject

@property (nonatomic, readonly) NSUInteger answerID;
@property (nonatomic, readonly) NSUInteger questionID;
@property (nonatomic, readonly) NSUInteger ownerID;

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *body;
@property (nonatomic, readonly) BOOL isAccepted;

@property (nonatomic, readonly) NSUInteger score;
@property (nonatomic, readonly) NSUInteger upVoteCount;
@property (nonatomic, readonly) NSUInteger downVoteCount;

@property (nonatomic, readonly) NSDate *creationDate;
@property (nonatomic, readonly) NSDate *lockedDate;
@property (nonatomic, readonly) NSDate *lastEditDate;
@property (nonatomic, readonly) NSDate *lastActivityDate;
@property (nonatomic, readonly) NSDate *communityOwnedDate;

@end
