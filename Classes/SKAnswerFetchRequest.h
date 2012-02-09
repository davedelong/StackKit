//
//  SKAnswerFetchRequest.h
//  StackKit
//
//  Created by Dave DeLong on 2/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <StackKit/SKFetchRequest_Internal.h>

@interface SKAnswerFetchRequest ()

@property (nonatomic, retain) NSMutableIndexSet *answerIDs;
@property (nonatomic, retain) NSMutableOrderedSet *tagNames;
@property (nonatomic, retain) NSMutableIndexSet *userIDs;
@property (nonatomic, retain) NSMutableIndexSet *questionIDs;

@end
