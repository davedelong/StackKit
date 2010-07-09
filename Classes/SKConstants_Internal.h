//
//  SKConstants_Internal.h
//  StackKit
/**
 Copyright (c) 2010 Dave DeLong
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 **/

#import "SKFunctions.h"

extern NSString * const SKFrameworkAPIKey;

extern NSString * const SKSortCreation;
extern NSString * const SKSortActivity;
extern NSString * const SKSortVotes;
extern NSString * const SKSortViews;
extern NSString * const SKSortNewest;
extern NSString * const SKSortFeatured;
extern NSString * const SKSortHot;
extern NSString * const SKSortWeek;
extern NSString * const SKSortMonth;
extern NSString * const SKSortAdded;
extern NSString * const SKSortPopular;
extern NSString * const SKSortReputation;
extern NSString * const SKSortName;

extern NSString * const SKQueryTrue;
extern NSString * const SKQueryFalse;

extern NSUInteger const SKPageSizeLimitMax;
extern NSString * const SKQueryPage;
extern NSString * const SKQueryPageSize;
extern NSString * const SKQuerySort;
extern NSString * const SKQuerySortOrder;
extern NSString * const SKQueryFromDate;
extern NSString * const SKQueryToDate;
extern NSString * const SKQueryMinSort;
extern NSString * const SKQueryMaxSort;
extern NSString * const SKQueryFilter;
extern NSString * const SKQueryBody;
extern NSString * const SKQueryTagged;

/**
 There are some cases where constants can have different names but the same value.  For example:
 - in SKUser:	SKUserID
 - in SKTag:	SKTagsParticipatedInByUser
 - in SKBadge:	SKBadgeAwardedToUser
 
 All three of those have the value of @"user_id", but it doesn't always make contextual sense to refer to them all as SKUserID.
 An SKBadge, for example, does not have an SKUserID.  However, it does know if it has been awarded to a particular user.
 
 To get around the trouble of defining @"user_id" in 3 different places, all three of these constants are declared like so:
 
 NSString * const SKWhateverThisConstantIs __SKUserID;
 
 __SKUserID is #defined below to be @"user_id".
 
 For reference, see http://stackoverflow.com/questions/2909724
 
 **/

#define __SKUserID @"user_id"
#define __SKPostScore @"score"
#define __SKPostCreationDate @"creation_date"
#define __SKPostOwner @"owner"
#define __SKPostBody @"body"
#define __SKQAPostLockedDate @"locked_date"
#define __SKQAPostLastEditDate @"last_edit_date"
#define __SKQAPostLastActivityDate @"last_activity_date"
#define __SKQAPostUpVotes @"up_vote_count"
#define __SKQAPostDownVotes @"down_vote_count"
#define __SKQAPostViewCount @"view_count"
#define __SKQAPostCommunityOwned @"community_owned"
#define __SKQAPostTitle @"title"
#define __SKQuestionID @"question_id"
#define __SKQuestionTags @"tags"
#define __SKQuestionAnswerCount @"answer_count"
#define __SKQuestionAcceptedAnswer @"accepted_answer_id"
#define __SKQuestionFavoriteCount @"favorite_count"
#define __SKQuestionBountyCloseDate @"bounty_closes_date"
#define __SKQuestionBountyAmount @"bounty_amount"
#define __SKQuestionCloseDate @"closed_date"
#define __SKQuestionCloseReason @"closed_reason"
#define __SKQuestionTimelineURL @"question_timeline_url"
#define __SKQuestionCommentsURL @"question_comments_url"
#define __SKQuestionAnswersURL @"question_answers_url"

#define __SKAnswerID @"answer_id"
#define __SKAnswerQuestion __SKQuestionID
#define __SKAnswerIsAccepted @"accepted"
#define __SKAnswerCommentsURL @"answer_comments_url"


#ifndef SKLog
#define SKLog(format,...) \
{ \
NSString *file = [[NSString alloc] initWithUTF8String:__FILE__]; \
printf("[%s:%d] ", [[file lastPathComponent] UTF8String], __LINE__); \
[file release]; \
SKQLog((format),##__VA_ARGS__); \
}
#endif