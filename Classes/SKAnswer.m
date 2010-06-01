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

+ (NSURL *) apiCallForFetchRequest:(SKFetchRequest *)request {
	/**
	 Valid endpoints:
	 
	 /answers/{id}
	 /questions/{id}/answers
	 /users/{id}/answers
	 
	 
	 Valid predicates:
	 
	 SKAnswerID = ##
	 SKQuestionID = ##
	 SKUserID = ##
	 **/
	
	if ([request predicate] == nil) {
		return SKInvalidPredicateErrorForFetchRequest(request, nil);
	}
	
	if ([[request predicate] isKindOfClass:[NSComparisonPredicate class]] == NO) {
		return SKInvalidPredicateErrorForFetchRequest(request, nil);
	}
	
	NSString * path = nil;
	NSComparisonPredicate * comparisonP = (NSComparisonPredicate *)[request predicate];
	
	NSArray * validLeftKeyPaths = [NSArray arrayWithObjects:SKAnswerID, SKQuestionID, SKUserID, nil];
	if ([comparisonP isComparisonPredicateWithLeftKeyPaths:validLeftKeyPaths operator:NSEqualToPredicateOperatorType rightExpressionType:NSConstantValueExpressionType] == NO) {
		return SKInvalidPredicateErrorForFetchRequest(request, nil);
	}
	
	id answerID = [comparisonP constantValueForLeftKeyPath:SKAnswerID];
	id questionID = [comparisonP constantValueForLeftKeyPath:SKQuestionID];
	id userID = [comparisonP constantValueForLeftKeyPath:SKUserID];
	
	if (answerID != nil) {
		answerID = SKExtractAnswerID(answerID);
		if (answerID == nil) {
			return SKInvalidPredicateErrorForFetchRequest(request, nil);
		}
		path = [NSString stringWithFormat:@"/answers/%@", answerID];
	} else if (questionID != nil) {
		questionID = SKExtractQuestionID(questionID);
		if (questionID == nil) {
			return SKInvalidPredicateErrorForFetchRequest(request, nil);
		}
		path = [NSString stringWithFormat:@"/questions/%@/answers", questionID];
	} else if (userID != nil) {
		userID = SKExtractUserID(userID);
		if (userID == nil) {
			return SKInvalidPredicateErrorForFetchRequest(request, nil);
		}
		path = [NSString stringWithFormat:@"/users/%@/answers", userID];
	} else {
		return SKInvalidPredicateErrorForFetchRequest(request, nil);
	}
	
	NSMutableDictionary * query = [request defaultQueryDictionary];
	
	return [[self class] constructAPICallForBaseURL:[[request site] apiURL] relativePath:path query:query];
}

@end
