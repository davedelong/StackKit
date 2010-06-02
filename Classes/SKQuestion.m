//
//  SKQuestion.m
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
NSString * const SKQuestionCreationDate = __SKPostCreationDate;
NSString * const SKQuestionOwner = __SKPostOwner;
NSString * const SKQuestionBody = __SKPostBody;
NSString * const SKQuestionScore = __SKPostScore;
NSString * const SKQuestionLockedDate = __SKQAPostLockedDate;
NSString * const SKQuestionLastEditDate = __SKQAPostLastEditDate;
NSString * const SKQuestionLastActivityDate = __SKQAPostLastActivityDate;
NSString * const SKQuestionUpVotes = __SKQAPostUpVotes;
NSString * const SKQuestionDownVotes = __SKQAPostDownVotes;
NSString * const SKQuestionViewCount = __SKQAPostViewCount;
NSString * const SKQuestionCommunityOwned = __SKQAPostCommunityOwned;
NSString * const SKQuestionTitle = __SKQAPostTitle;

NSString * const SKQuestionID = __SKQuestionID;
NSString * const SKQuestionTags = __SKQuestionTags;
NSString * const SKQuestionAnswerCount = __SKQuestionAnswerCount;
NSString * const SKQuestionAcceptedAnswer = __SKQuestionAcceptedAnswer;
NSString * const SKQuestionFavoriteCount = __SKQuestionFavoriteCount;
NSString * const SKQuestionBountyCloseDate = __SKQuestionBountyCloseDate;
NSString * const SKQuestionBountyAmount = __SKQuestionBountyAmount;
NSString * const SKQuestionCloseDate = __SKQuestionCloseDate;
NSString * const SKQuestionCloseReason = __SKQuestionCloseReason;
NSString * const SKQuestionTimelineURL = __SKQuestionTimelineURL;
NSString * const SKQuestionCommentsURL = __SKQuestionCommentsURL;
NSString * const SKQuestionAnswersURL = __SKQuestionAnswersURL;

NSString * const SKQuestionsFavoritedByUser = @"question_favorited_by_user";

@implementation SKQuestion

@synthesize questionID;
@synthesize tags;
@synthesize answerCount;
@synthesize acceptedAnswerID;
@synthesize favoriteCount;
@synthesize bountyCloseDate;
@synthesize bountyAmount;
@synthesize closeDate;
@synthesize closeReason;
@synthesize timelineURL;
@synthesize commentsURL;
@synthesize answersURL;

+ (NSString *) dataKey {
	return @"questions";
}

+ (NSDictionary *) validPredicateKeyPaths {
	NSMutableDictionary * d = [NSMutableDictionary dictionaryWithObjectsAndKeys:
							   SKQuestionID, @"questionID",
							   SKQuestionAnswerCount, @"answerCount",
							   SKQuestionTags, @"tags",
							   SKQuestionsFavoritedByUser, SKQuestionsFavoritedByUser,
							   nil];
	[d addEntriesFromDictionary:[super validPredicateKeyPaths]];
	return d;
}

+ (NSURL *) apiCallForFetchRequest:(SKFetchRequest *)request {
	/**
	 Possible endpoints:
	 
	 /questions
	 /questions/{id}
	 /questions/tagged/{tags}
	 /questions/unanswered
	 /users/{id}/favorites
	 /users/{id}/questions
	 
	 Which means the possible predicates are:
	 
	 (none)
	 SKQuestionID = ##
	 SKQuestionTags CONTAINS (tags)
	 SKQuestionAnswerCount = 0
	 SKQuestionFavoritedByUser = ##
	 SKPostOwner = ##
	 
	 **/
	
	NSString * path = nil;
	NSPredicate * p = [request predicate];
	if (p != nil) {
		//it *must* be a comparison predicate
		if ([p isKindOfClass:[NSComparisonPredicate class]] == NO) {
			return SKInvalidPredicateErrorForFetchRequest(request, nil);
		}
		
		NSArray * simpleLeftKeyPaths = [NSArray arrayWithObjects:SKQuestionID, SKQuestionAnswerCount, SKQuestionsFavoritedByUser, SKPostOwner, nil];
		if ([p isComparisonPredicateWithLeftKeyPaths:simpleLeftKeyPaths operator:NSEqualToPredicateOperatorType rightExpressionType:NSConstantValueExpressionType]) {
			id questionID = [p constantValueForLeftKeyPath:SKQuestionID];
			id answerCount = [p constantValueForLeftKeyPath:SKQuestionAnswerCount];
			id favByUser = [p constantValueForLeftKeyPath:SKQuestionsFavoritedByUser];
			id owner = [p constantValueForLeftKeyPath:SKPostOwner];
			
			if (questionID != nil) {
				questionID = SKExtractQuestionID(questionID);
				path = [NSString stringWithFormat:@"/questions/%@", questionID];
			} else if (answerCount != nil) {
				if ([answerCount intValue] != 0) {
					return SKInvalidPredicateErrorForFetchRequest(request, nil);
				}
				path = @"/questions/unanswered";
			} else if (favByUser != nil) {
				favByUser = SKExtractUserID(favByUser);
				if (favByUser == nil) {
					return SKInvalidPredicateErrorForFetchRequest(request, nil);
				}
				path = [NSString stringWithFormat:@"/users/%@/favorites", favByUser];
			} else if (owner != nil) {
				owner = SKExtractUserID(owner);
				if (owner == nil) {
					return SKInvalidPredicateErrorForFetchRequest(request, nil);
				}
				path = [NSString stringWithFormat:@"/users/%@/questions", owner];
			} else {
				return SKInvalidPredicateErrorForFetchRequest(request, nil);
			}
		} else if ([p isComparisonPredicateWithLeftKeyPaths:[NSArray arrayWithObject:SKQuestionTags] operator:NSContainsPredicateOperatorType rightExpressionType:NSConstantValueExpressionType]) {
			id names = [p constantValueForLeftKeyPath:SKQuestionTags];
			NSArray * tagNames = SKExtractTagNames(names);
			if (tagNames == nil) {
				return SKInvalidPredicateErrorForFetchRequest(request, nil);
			}
			NSString * pathTags = [tagNames componentsJoinedByString:@";"];
			path = [NSString stringWithFormat:@"/questions/tagged/%@", pathTags];
		} else {
			return SKInvalidPredicateErrorForFetchRequest(request, nil);
		}
	} else {
		path = @"/questions";
	}
	
	NSMutableDictionary * query = [request defaultQueryDictionary];
	
	return [[self class] constructAPICallForBaseURL:[[request site] apiURL] relativePath:path query:query];
}

@end
