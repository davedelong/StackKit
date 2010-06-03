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

+ (NSArray *) endpoints {
	return [NSArray arrayWithObjects:
			[SKAllQuestionsEndpoint class],
			[SKUserQuestionsEndpoint class],
			[SKSpecificQuestionEndpoint class],
			[SKQuestionsTaggedEndpoint class],
			[SKUnansweredQuestionsEndpoint class],
			[SKUserFavoritedQuestionsEndpoint class],
			[SKQuestionSearchEndpoint class],
			nil];
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

- (id) initWithSite:(SKSite *)aSite dictionaryRepresentation:(NSDictionary *)dictionary {
	if (self = [super initWithSite:aSite dictionaryRepresentation:dictionary]) {
		questionID = [[dictionary objectForKey:SKQuestionID] retain];
		answerCount = [[dictionary objectForKey:SKQuestionAnswerCount] retain];
		acceptedAnswerID = [[dictionary objectForKey:SKQuestionAcceptedAnswer] retain];
		favoriteCount = [[dictionary objectForKey:SKQuestionFavoriteCount] retain];
		bountyCloseDate = [[dictionary objectForKey:SKQuestionBountyCloseDate] retain];
		bountyAmount = [[dictionary objectForKey:SKQuestionBountyAmount] retain];
		closeDate = [[dictionary objectForKey:SKQuestionCloseDate] retain];
		closeReason = [[dictionary objectForKey:SKQuestionCloseReason] retain];
		
		timelineURL = [[NSURL alloc] initWithString:[dictionary objectForKey:SKQuestionTimelineURL]];
		commentsURL = [[NSURL alloc] initWithString:[dictionary objectForKey:SKQuestionCommentsURL]];
		answersURL = [[NSURL alloc] initWithString:[dictionary objectForKey:SKQuestionAnswersURL]];
	}
	return self;
}

- (void) dealloc {
	[questionID release];
	[answerCount release];
	[acceptedAnswerID release];
	[favoriteCount release];
	[bountyCloseDate release];
	[bountyAmount release];
	[closeDate release];
	[closeReason release];
	[timelineURL release];
	[commentsURL release];
	[answersURL release];
	[super dealloc];
}

@end
