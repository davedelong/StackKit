//
//  SKAnswerFetchRequest.h
//  StackKit
//
//  Created by Dave DeLong on 2/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <StackKit/SKFetchRequest_Internal.h>

@interface SKAnswerFetchRequest ()

@property (readonly) NSMutableIndexSet *answerIDs;
@property (readonly) NSMutableOrderedSet *tagNames;
@property (readonly) NSMutableIndexSet *userIDs;
@property (readonly) NSMutableIndexSet *questionIDs;

@end
