//
//  SKAnswerFetchRequest.m
//  StackKit
//
//  Created by Dave DeLong on 2/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SKAnswerFetchRequest.h"
#import <StackKit/SKFunctions.h>
#import <StackKit/SKConstants.h>
#import <StackKit/SKAnswer.h>
#import <StackKit/SKUser.h>
#import <StackKit/SKTag.h>
#import <StackKit/SKQuestion.h>
#import <StackKit/SKMacros.h>

@implementation SKAnswerFetchRequest

@synthesize answerIDs=_answerIDs;
@synthesize tagNames=_tagNames;
@synthesize userIDs=_userIDs;
@synthesize questionIDs=_questionIDs;

+ (Class)_targetClass { return [SKAnswer class]; }

- (id)init {
    self = [super init];
    if (self) {
        _answerIDs = [[NSMutableIndexSet alloc] init];
        _tagNames = [[NSMutableOrderedSet alloc] init];
        _userIDs = [[NSMutableIndexSet alloc] init];
        _questionIDs = [[NSMutableIndexSet alloc] init];
    }
    return self;
}

- (void)dealloc {
    [_answerIDs release];
    [_tagNames release];
    [_userIDs release];
    [_questionIDs release];
    [super dealloc];
}

- (id)sortedByScore {
    [self setSortKey:SKSortValues.answer.score];
    return self;
}

- (id)sortedByLastActivityDate {
    [self setSortKey:SKSortValues.answer.lastActivityDate];
    return self;
}

- (id)sortedByCreationDate {
    [self setSortKey:SKSortValues.answer.creationDate];
    return self;
}

- (id)withIDs:(NSUInteger)answerID, ... {
    INTEGER_LIST(_answerIDs, answerID);
    return self;    
}

- (id)postedinTags:(SKTag *)tag, ... {
    if (tag != nil) {
        [_tagNames addObject:[tag name]];
        va_list list;
        va_start(list, tag);
        
        while((tag = va_arg(list, SKTag*)) != nil) {
            [_tagNames addObject:[tag name]];
        }
        
        va_end(list);
    }
    return self;
}

- (id)postedinTagsWithNames:(NSString *)tag, ... {
    if (tag != nil) {
        [_tagNames addObject:tag];
        va_list list;
        va_start(list, tag);
        
        while((tag = va_arg(list, NSString*)) != nil) {
            [_tagNames addObject:tag];
        }
        
        va_end(list);
    }
    return self;    
}

- (id)postedOnQuestions:(SKQuestion *)question, ... {
    OBJECT_LIST(_questionIDs, question, postID);
    return self;
}

- (id)postedOnQuestionsWithIDs:(NSUInteger)questionID, ... {
    INTEGER_LIST(_questionIDs, questionID);
    return self;
}

- (id)postedByUsers:(SKUser *)user, ...  {
    OBJECT_LIST(_userIDs, user, userID);
    return self;
}

- (id)postedByUsersWithIDs:(NSUInteger)userID, ...  {
    INTEGER_LIST(_userIDs, userID);
    return self;
}

- (NSString *)_path {
    if ([_tagNames count] > 5) {
        // the API only accepts up to 5 tag names
        [_tagNames removeObjectsInRange:NSMakeRange(5, [_tagNames count]-5)];
    }
    
    if ([_answerIDs count] > 0) {
        return [NSString stringWithFormat:@"answers/%@", SKQueryString(_answerIDs)];
    }
    if ([_questionIDs count] > 0) {
        return [NSString stringWithFormat:@"questions/%@/answers", SKQueryString(_questionIDs)];
    }
    if ([_userIDs count] > 0) {
        if ([_tagNames count] > 0) {
            return [NSString stringWithFormat:@"users/%lu/tags/%@/top-answers", [_userIDs firstIndex], SKQueryString(_tagNames)];
        } else {
            return [NSString stringWithFormat:@"users/%@/answers", SKQueryString(_userIDs)];
        }
    }
    
    return @"answers";
}

- (NSMutableDictionary *)_queryDictionary {
    NSMutableDictionary *d = [super _queryDictionary];
    
    // I don't believe anything needs to be modified here
    
    return d;
}

@end
