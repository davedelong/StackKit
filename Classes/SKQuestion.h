//
//  SKQuestion.h
//  StackKit
//
//  Created by Dave DeLong on 2/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <StackKit/SKObject.h>
#import <StackKit/SKPost.h>

@interface SKQuestion : SKObject <SKPost>

@property (readonly) NSDate *lastEditDate;
@property (readonly) NSDate *lastActivityDate;
@property (readonly) NSDate *lockedDate;
@property (readonly) NSDate *communityOwnedDate;
@property (readonly) NSUInteger answerCount;
@property (readonly) NSUInteger acceptedAnswerID;
@property (readonly) NSDate *bountyClosesDate;
@property (readonly) NSUInteger bountyAmount;
@property (readonly) NSDate *closedDate;
@property (readonly) NSDate *protectedDate;
@property (readonly) NSString *title;
@property (readonly) NSString *closedReason;
@property (readonly) NSUInteger upVoteCount;
@property (readonly) NSUInteger downVoteCount;
@property (readonly) NSUInteger favoriteCount;
@property (readonly) NSUInteger viewCount;
@property (readonly) BOOL isAnswered;

@end
