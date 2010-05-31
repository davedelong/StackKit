//
//  SKQuestion.h
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

#import <Foundation/Foundation.h>
#import "SKQuestion.h"

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


@interface SKQuestion : SKQAPost {
	NSNumber * questionID;
	
	NSSet * tags;
	NSNumber * answerCount;
	NSNumber * acceptedAnswerID;
	NSNumber * favoriteCount;
	NSDate * bountyCloseDate;
	NSNumber * bountyAmount;
	NSDate * closeDate;
	NSString * closeReason;
	
	NSURL * timelineURL;
	NSURL * commentsURL;
	NSURL * answersURL;
}

@property (readonly) NSNumber * questionID;
@property (readonly) NSSet * tags;
@property (readonly) NSNumber * answerCount;
@property (readonly) NSNumber * acceptedAnswerID;
@property (readonly) NSNumber * favoriteCount;
@property (readonly) NSDate * bountyCloseDate;
@property (readonly) NSNumber * bountyAmount;
@property (readonly) NSDate * closeDate;
@property (readonly) NSString * closeReason;
@property (readonly) NSURL * timelineURL;
@property (readonly) NSURL * commentsURL;
@property (readonly) NSURL * answersURL;

@end
