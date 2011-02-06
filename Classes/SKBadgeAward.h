//
//  SKBadgeAward.h
//  StackKit
//
//  Created by Dave DeLong on 1/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "SKObject.h"

@class SKBadge;
@class SKUser;

@interface SKBadgeAward : SKObject  
{
}

@property (nonatomic, readonly) NSNumber * numberOfTimesAwarded;
@property (nonatomic, readonly) SKUser * user;
@property (nonatomic, readonly) SKBadge * badge;

@end



