// 
//  SKQuestion.m
//  StackKit
//
//  Created by Dave DeLong on 1/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SKQuestion.h"
#import "SKConstants_Internal.h"
#import "SKObject+Private.h"

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
NSString * const SKQuestionFavoritedDate = @"question_favorited_date";

@implementation SKQuestion 

@dynamic closeDate;
@dynamic bountyAmount;
@dynamic bountyCloseDate;
@dynamic closeReason;
@dynamic favoriteCount;
@dynamic answers;
@dynamic tags;

+ (NSDictionary *)APIAttributeToPropertyMapping {
    static NSDictionary *mapping = nil;
    if (!mapping) {
        mapping = [[super APIAttributeToPropertyMapping] mutableCopy];
        [(NSMutableDictionary *)mapping addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                  @"closeDate", SKQuestionCloseDate,
                                                                  @"bountyAmount", SKQuestionBountyAmount,
                                                                  @"bountyCloseDate", SKQuestionBountyCloseDate,
                                                                  @"closeReason", SKQuestionCloseReason,
                                                                  @"favoriteCount", SKQuestionFavoriteCount,
                                                                  nil]];
    }
    return mapping;
}

+ (NSString *)apiResponseDataKey {
    return @"questions";
}

+ (NSString *)apiResponseUniqueIDKey {
    return SKQuestionID;
}

@end
