//
//  SKQuestion.h
//  StackKit
//
//  Created by Dave DeLong on 1/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "SKQAPost.h"

//inherited
extern NSString * const SKQuestionCreationDate;
extern NSString * const SKQuestionOwner;
extern NSString * const SKQuestionBody;
extern NSString * const SKQuestionScore;
extern NSString * const SKQuestionLockedDate;
extern NSString * const SKQuestionLastEditDate;
extern NSString * const SKQuestionLastActivityDate;
extern NSString * const SKQuestionUpVotes;
extern NSString * const SKQuestionDownVotes;
extern NSString * const SKQuestionViewCount;
extern NSString * const SKQuestionCommunityOwned;
extern NSString * const SKQuestionTitle;

extern NSString * const SKQuestionID;
extern NSString * const SKQuestionTags;
extern NSString * const SKQuestionAnswerCount;
extern NSString * const SKQuestionAcceptedAnswer;
extern NSString * const SKQuestionFavoriteCount;
extern NSString * const SKQuestionBountyCloseDate;
extern NSString * const SKQuestionBountyAmount;
extern NSString * const SKQuestionCloseDate;
extern NSString * const SKQuestionCloseReason;
extern NSString * const SKQuestionTimelineURL;
extern NSString * const SKQuestionCommentsURL;
extern NSString * const SKQuestionAnswersURL;

extern NSString * const SKQuestionsFavoritedByUser;
extern NSString * const SKQuestionFavoritedDate;

@interface SKQuestion :  SKQAPost  
{
}

@property (nonatomic, readonly) NSDate * closeDate;
@property (nonatomic, readonly) NSNumber * bountyAmount;
@property (nonatomic, readonly) NSDate * bountyCloseDate;
@property (nonatomic, readonly) NSString * closeReason;
@property (nonatomic, readonly) NSNumber * favoriteCount;
@property (nonatomic, readonly) NSSet* answers;
@property (nonatomic, readonly) NSSet* tags;

@end

