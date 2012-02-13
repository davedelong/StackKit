//
//  SKQuestionFetchRequest.m
//  StackKit
//
//  Created by Dave DeLong on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SKQuestionFetchRequest.h"
#import <StackKit/SKFunctions.h>
#import <StackKit/SKConstants.h>
#import <StackKit/SKQuestion.h>
#import <StackKit/SKMacros.h>
#import <StackKit/SKUser.h>

@implementation SKQuestionFetchRequest

@synthesize questionIDs=_questionIDs;
@synthesize userIDsWhoPosted=_userIDsWhoPosted;
@synthesize userIDsWhoFavorited=_userIDsWhoFavorited;

@synthesize wantsLinkedQuestions=_wantsLinkedQuestions;
@synthesize wantsRelatedQuestions=_wantsRelatedQuestions;

@synthesize wantsQuestionsWithNoAnswers=_wantsQuestionsWithNoAnswers;
@synthesize wantsQuestionsWithNoAcceptedAnswer=_wantsQuestionsWithNoAcceptedAnswer;
@synthesize wantsQuestionsWithInsufficientAnswers=_wantsQuestionsWithInsufficientAnswers;

+ (Class)_targetClass { return [SKQuestion class]; }

- (id)init {
    self = [super init];
    if (self) {
        _questionIDs = [[NSMutableIndexSet alloc] init];
        _userIDsWhoFavorited = [[NSMutableIndexSet alloc] init];
        _userIDsWhoPosted = [[NSMutableIndexSet alloc] init];
    }
    return self;
}

- (void)dealloc {
    [_questionIDs release];
    [_userIDsWhoFavorited release];
    [_userIDsWhoPosted release];
    [super dealloc];
}

- (id)sortedByCreationDate {
    [self setSortKey:SKSortValues.question.creationDate];
    return self;
}

- (id)sortedByScore {
    [self setSortKey:SKSortValues.question.score];
    return self;
}

- (id)sortedByLastActivityDate {
    [self setSortKey:SKSortValues.question.lastActivityDate];
    return self;
}

- (id)withIDs:(NSUInteger)questionID, ... {
    INTEGER_LIST(_questionIDs, questionID);
    return self;  
}

- (id)linkedFromQuestionsWithIDs:(NSUInteger)questionID, ... {
    INTEGER_LIST(_questionIDs, questionID);
    _wantsLinkedQuestions = YES;
    return self;
}

- (id)relatedToQuestionsWithIDs:(NSUInteger)questionID, ... {
    INTEGER_LIST(_questionIDs, questionID);
    _wantsRelatedQuestions = YES;
    return self;
}

- (id)thatAreInsufficientlyAnswered {
    _wantsQuestionsWithInsufficientAnswers = YES;
    return self;
}

- (id)thatHaveNoAnswers {
    _wantsQuestionsWithNoAnswers = YES;
    return self;
}

- (id)thatHaveNoAcceptedAnswer {
    _wantsQuestionsWithNoAcceptedAnswer = YES;
    return self;
}

- (id)favoritedByUsers:(SKUser *)user, ... {
    OBJECT_LIST(_userIDsWhoFavorited, user, userID);
    return self;
}

- (id)favoritedByUsersWithIDs:(NSUInteger)userID, ... {
    INTEGER_LIST(_userIDsWhoFavorited, userID);
    return self;
}

- (id)postedByUsers:(SKUser *)user, ... {
    OBJECT_LIST(_userIDsWhoPosted, user, userID);
    return self;
}

- (id)postedByUsersWithIDs:(NSUInteger)userID, ... {
    INTEGER_LIST(_userIDsWhoPosted, userID);
    return self;
}

- (NSString *)_path {
    if ([_questionIDs count] > 0) {
        NSString *ids = SKQueryString(_questionIDs);
        if (_wantsLinkedQuestions) {
            return [NSString stringWithFormat:@"questions/%@/linked", ids];
        }
        if (_wantsRelatedQuestions) {
            return [NSString stringWithFormat:@"questions/%@/related", ids];
        }
        return [NSString stringWithFormat:@"questions/%@", ids];
    }
    
    if ([_userIDsWhoPosted count] > 0) {
        NSString *ids = SKQueryString(_userIDsWhoPosted);
        if (_wantsQuestionsWithNoAnswers) {
            return [NSString stringWithFormat:@"users/%@/questions/no-answers", ids];
        }
        if (_wantsQuestionsWithInsufficientAnswers) {
            return [NSString stringWithFormat:@"users/%@/questions/unanswered", ids];
        }
        if (_wantsQuestionsWithNoAcceptedAnswer) {
            return [NSString stringWithFormat:@"users/%@/questions/unaccepted", ids];
        }
        return [NSString stringWithFormat:@"users/%@/questions", ids];
    }
    
    if ([_userIDsWhoFavorited count] > 0) {
        return [NSString stringWithFormat:@"users/%@/favorites", SKQueryString(_userIDsWhoFavorited)];
    }
    
    if (_wantsQuestionsWithNoAnswers) {
        return @"questions/no-answers";
    }
    
    if (_wantsQuestionsWithInsufficientAnswers) {
        return @"questions/unanswered";
    }
    
    return @"questions";
}

- (NSMutableDictionary *)_queryDictionary {
    NSMutableDictionary *d = [super _queryDictionary];
    
    return d;
}

@end
