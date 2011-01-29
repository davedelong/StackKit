//
//  SKQuestion+Private.h
//  StackKit
//
//  Created by Dave DeLong on 1/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKQuestion.h"

@class SKAnswer;
@class SKTag;

@interface SKQuestion (Private)

@property (nonatomic, retain) NSDate * closeDate;
@property (nonatomic, retain) NSNumber * bountyAmount;
@property (nonatomic, retain) NSDate * bountyCloseDate;
@property (nonatomic, retain) NSString * closeReason;
@property (nonatomic, retain) NSNumber * favoriteCount;
@property (nonatomic, retain) NSSet* answers;
@property (nonatomic, retain) NSSet* tags;

@end


@interface SKQuestion (CoreDataGeneratedAccessors)
- (void)addAnswersObject:(SKAnswer *)value;
- (void)removeAnswersObject:(SKAnswer *)value;
- (void)addAnswers:(NSSet *)value;
- (void)removeAnswers:(NSSet *)value;

- (void)addTagsObject:(SKTag *)value;
- (void)removeTagsObject:(SKTag *)value;
- (void)addTags:(NSSet *)value;
- (void)removeTags:(NSSet *)value;

@end
