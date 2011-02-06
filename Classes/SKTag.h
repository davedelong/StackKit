//
//  SKTag.h
//  StackKit
//
//  Created by Dave DeLong on 1/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "SKObject.h"

extern NSString * const SKTagName;
extern NSString * const SKTagCount;
extern NSString * const SKTagsParticipatedInByUser;

extern NSString * const SKTagNumberOfTaggedQuestions;
extern NSString * const SKTagLastUsedDate;

@interface SKTag : SKObject  
{
}

@property (nonatomic, readonly) NSString * name;
@property (nonatomic, readonly) NSNumber * numberOfTaggedQuestions;
@property (nonatomic, readonly) NSSet* questions;

@end

