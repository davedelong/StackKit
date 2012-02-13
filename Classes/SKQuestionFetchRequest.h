//
//  SKQuestionFetchRequest.h
//  StackKit
//
//  Created by Dave DeLong on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <StackKit/SKFetchRequest_Internal.h>

@interface SKQuestionFetchRequest ()

@property (readonly) NSMutableIndexSet *questionIDs;
@property (readonly) NSMutableIndexSet *userIDsWhoPosted;
@property (readonly) NSMutableIndexSet *userIDsWhoFavorited;

@property (readonly) BOOL wantsQuestionsWithNoAnswers;
@property (readonly) BOOL wantsQuestionsWithNoAcceptedAnswer;
@property (readonly) BOOL wantsQuestionsWithInsufficientAnswers;

@property (readonly) BOOL wantsLinkedQuestions;
@property (readonly) BOOL wantsRelatedQuestions;

@end
