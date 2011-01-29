//
//  SKQuestion.h
//  StackKit
//
//  Created by Dave DeLong on 1/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "SKQAPost.h"

@interface SKQuestion :  SKQAPost  
{
}

@property (nonatomic, retain, readonly) NSDate * closeDate;
@property (nonatomic, retain, readonly) NSNumber * bountyAmount;
@property (nonatomic, retain, readonly) NSDate * bountyCloseDate;
@property (nonatomic, retain, readonly) NSString * closeReason;
@property (nonatomic, retain, readonly) NSNumber * favoriteCount;
@property (nonatomic, retain, readonly) NSSet* answers;
@property (nonatomic, retain, readonly) NSSet* tags;

@end

