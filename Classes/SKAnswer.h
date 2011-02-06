//
//  SKAnswer.h
//  StackKit
//
//  Created by Dave DeLong on 1/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "SKQAPost.h"

//inherited
extern NSString * const SKAnswerCreationDate;
extern NSString * const SKAnswerOwner;
extern NSString * const SKAnswerBody;
extern NSString * const SKAnswerScore;
extern NSString * const SKAnswerLockedDate;
extern NSString * const SKAnswerLastEditDate;
extern NSString * const SKAnswerLastActivityDate;
extern NSString * const SKAnswerUpVotes;
extern NSString * const SKAnswerDownVotes;
extern NSString * const SKAnswerViewCount;
extern NSString * const SKAnswerCommunityOwned;
extern NSString * const SKAnswerTitle;

extern NSString * const SKAnswerID;
extern NSString * const SKAnswerQuestion;
extern NSString * const SKAnswerIsAccepted;

@class SKQuestion;

@interface SKAnswer :  SKQAPost  
{
}

@property (nonatomic, readonly) NSNumber * accepted;
@property (nonatomic, readonly) SKQuestion * question;

@end



