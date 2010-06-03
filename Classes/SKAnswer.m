//
//  SKAnswer.m
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

#import "StackKit_Internal.h"

//inherited
NSString * const SKAnswerCreationDate = __SKPostCreationDate;
NSString * const SKAnswerOwner = __SKPostOwner;
NSString * const SKAnswerBody = __SKPostBody;
NSString * const SKAnswerScore = __SKPostScore;
NSString * const SKAnswerLockedDate = __SKQAPostLockedDate;
NSString * const SKAnswerLastEditDate = __SKQAPostLastEditDate;
NSString * const SKAnswerLastActivityDate = __SKQAPostLastActivityDate;
NSString * const SKAnswerUpVotes = __SKQAPostUpVotes;
NSString * const SKAnswerDownVotes = __SKQAPostDownVotes;
NSString * const SKAnswerViewCount = __SKQAPostViewCount;
NSString * const SKAnswerCommunityOwned = __SKQAPostCommunityOwned;
NSString * const SKAnswerTitle = __SKQAPostTitle;

NSString * const SKAnswerID = __SKAnswerID;
NSString * const SKAnswerQuestion = __SKAnswerQuestion;
NSString * const SKAnswerIsAccepted = __SKAnswerIsAccepted;
NSString * const SKAnswerCommentsURL = __SKAnswerCommentsURL;

@implementation SKAnswer

@synthesize answerID, questionID, accepted, commentsURL;

+ (NSString *) dataKey {
	return @"answers";
}

+ (NSArray *) endpoints {
	return [NSArray arrayWithObjects:
			[SKSpecificAnswerEndpoint class],
			[SKQuestionAnswersEndpoint class],
			[SKUserAnswersEndpoint class],
			nil];
}

+ (NSDictionary *) validPredicateKeyPaths {
	NSMutableDictionary * d = [NSMutableDictionary dictionaryWithObjectsAndKeys:
							   SKAnswerID, @"answerID",
							   SKAnswerQuestion, @"questionID",
							   nil];
	[d addEntriesFromDictionary:[super validPredicateKeyPaths]];
	return d;
}

@end
