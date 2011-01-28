//
//  SKTag+Private.h
//  StackKit
//
//  Created by Dave DeLong on 1/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKTag.h"

@interface SKTag (Private)

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * numberOfTaggedQuestions;
@property (nonatomic, retain) NSSet* questions;

@end


@interface SKTag (CoreDataGeneratedAccessors)
- (void)addQuestionsObject:(SKQuestion *)value;
- (void)removeQuestionsObject:(SKQuestion *)value;
- (void)addQuestions:(NSSet *)value;
- (void)removeQuestions:(NSSet *)value;

@end
