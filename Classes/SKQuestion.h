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

@property (nonatomic, readonly) NSNumber * questionID;
@property (nonatomic, readonly) NSDate * closeDate;
@property (nonatomic, readonly) NSNumber * bountyAmount;
@property (nonatomic, readonly) NSDate * bountyCloseDate;
@property (nonatomic, readonly) NSString * closeReason;
@property (nonatomic, readonly) NSNumber * favoriteCount;

@property (nonatomic, readonly) NSSet* answers;
@property (nonatomic, readonly) NSSet* tags;

@end

