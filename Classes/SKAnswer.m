// 
//  SKAnswer.m
//  StackKit
//
//  Created by Dave DeLong on 1/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SKAnswer.h"
#import "SKConstants_Internal.h"
#import "SKObject+Private.h"
#import "SKQuestion.h"

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

@dynamic accepted;
@dynamic question;

+ (NSDictionary *)APIAttributeToPropertyMapping {
    static NSDictionary *mapping = nil;
    if (!mapping) {
        mapping = [[super APIAttributeToPropertyMapping] mutableCopy];
        [(NSMutableDictionary *)mapping addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                  @"postID", SKAnswerID, // inherited from SKPost
                                                                  @"accepted", SKAnswerIsAccepted,
                                                                  @"question", SKAnswerQuestion,
                                                                  nil]];
    }
    return mapping;
}

+ (NSString *) apiResponseDataKey {
	return @"answers";
}

+ (NSString *) apiResponseUniqueIDKey {
	return SKAnswerID;
}

@end
