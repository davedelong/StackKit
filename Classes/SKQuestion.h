//
//  SKQuestion.h
//  StackKit
//
//  Created by Dave DeLong on 2/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <StackKit/SKObject.h>

@interface SKQuestion : SKObject

@property (nonatomic, readonly) NSUInteger questionID;
@property (nonatomic, readonly) NSDate *lastEditDate;
@property (nonatomic, readonly) NSDate *creationDate;
@property (nonatomic, readonly) NSDate *lastActivityDate;
@property (nonatomic, readonly) NSDate *lockedDate;
@property (nonatomic, readonly) NSUInteger score;
@property (nonatomic, readonly) NSDate *communityOwnedDate;
@property (nonatomic, readonly) NSUInteger answerCount;
@property (nonatomic, readonly) NSUInteger acceptedAnswerID;
@property (nonatomic, readonly) NSDate *bountyClosesDate;
@property (nonatomic, readonly) NSUInteger bountyAmount;
@property (nonatomic, readonly) NSDate *closedDate;
@property (nonatomic, readonly) NSDate *protectedDate;
@property (nonatomic, readonly) NSString *body;
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *closedReason;
@property (nonatomic, readonly) NSUInteger upVoteCount;
@property (nonatomic, readonly) NSUInteger downVoteCount;
@property (nonatomic, readonly) NSUInteger favoriteCount;
@property (nonatomic, readonly) NSUInteger viewCount;
@property (nonatomic, readonly) NSUInteger ownerID;
@property (nonatomic, readonly) BOOL isAnswered;

@end
