//
//  SKBadge+Private.h
//  StackKit
//
//  Created by Dave DeLong on 1/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKBadge.h"

@interface SKBadge (Private)

@property (nonatomic, retain) NSNumber * badgeID;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * rank;
@property (nonatomic, retain) NSNumber * numberAwarded;
@property (nonatomic, retain) NSNumber * tagBased;
@property (nonatomic, retain) NSSet* users;

@end

@class SKUser;

@interface SKBadge (CoreDataGeneratedAccessors)
- (void)addUsersObject:(SKUser *)value;
- (void)removeUsersObject:(SKUser *)value;
- (void)addUsers:(NSSet *)value;
- (void)removeUsers:(NSSet *)value;

@end