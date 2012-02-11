//
//  SKBadge.h
//  StackKit
//
//  Created by Dave DeLong on 1/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <StackKit/SKObject.h>
#import <StackKit/SKTypes.h>

@interface SKBadge : SKObject

@property (readonly) NSUInteger badgeID;
@property (readonly) NSString *name;
@property (readonly) SKBadgeRank rank;
@property (readonly, getter=isTagBased) BOOL tagBased;

@end
