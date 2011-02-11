//
//  SKBadge.h
//  StackKit
//
//  Created by Dave DeLong on 1/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "SKObject.h"

@interface SKBadge : SKObject  
{
}

@property (nonatomic, readonly) NSNumber * badgeID;
@property (nonatomic, readonly) NSString * name;
@property (nonatomic, readonly) NSNumber * numberAwarded;
@property (nonatomic, readonly) NSNumber * rank;
@property (nonatomic, readonly) NSString * summary;
@property (nonatomic, readonly) NSNumber * tagBased;

@property (nonatomic, readonly) NSSet* awards;

@end

