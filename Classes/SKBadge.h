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

@property (nonatomic, readonly) NSUInteger badgeID;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) SKBadgeRank rank;
@property (nonatomic, readonly, getter=isTagBased) BOOL tagBased;

@end
