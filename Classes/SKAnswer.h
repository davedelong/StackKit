//
//  SKAnswer.h
//  StackKit
/**
  Copyright (c) 2011 Dave DeLong
 
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
#import "SKAnswer.h"

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
extern NSString * const SKAnswerCommentsURL;

@class SKQuestion;

@interface SKAnswer : SKQAPost {
	NSNumber * answerID;
	NSNumber * questionID;
	NSNumber * accepted;
	NSURL * commentsURL;
}

@property (readonly) NSNumber * answerID;
@property (readonly) NSNumber * questionID;
@property (readonly) NSNumber * accepted;
@property (readonly) NSURL * commentsURL;

@end
