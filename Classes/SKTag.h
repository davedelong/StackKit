//
//  SKTag.h
//  StackKit
//
//  Created by Dave DeLong on 1/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "SKObject.h"

@class SKQuestion;

@interface SKTag :  SKObject  
{
}

@property (nonatomic, retain, readonly) NSString * name;
@property (nonatomic, retain, readonly) NSNumber * numberOfTaggedQuestions;
@property (nonatomic, retain, readonly) NSSet* questions;

@end

