//
//  SKBadge.h
//  StackKit
//
//  Created by Dave DeLong on 1/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "SKObject.h"

@interface SKBadge :  SKObject  
{
}

@property (nonatomic, retain, readonly) NSNumber * badgeID;
@property (nonatomic, retain, readonly) NSString * summary;
@property (nonatomic, retain, readonly) NSString * name;
@property (nonatomic, retain, readonly) NSNumber * rank;
@property (nonatomic, retain, readonly) NSNumber * numberAwarded;
@property (nonatomic, retain, readonly) NSNumber * tagBased;
@property (nonatomic, retain, readonly) NSSet* users;

@end

