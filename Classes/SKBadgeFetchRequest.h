//
//  SKBadgeFetchRequest.h
//  StackKit
//
//  Created by Dave DeLong on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <StackKit/SKFetchRequest_Internal.h>

typedef enum {
    _SKBadgeTypeAll,
    _SKBadgeTypeTag,
    _SKBadgeTypeNamed
} _SKBadgeType;

@interface SKBadgeFetchRequest ()

@property (nonatomic, retain) NSMutableIndexSet *userIDs;
@property (nonatomic, retain) NSMutableIndexSet *badgeIDs;
@property (nonatomic, assign) _SKBadgeType requestedType;
@property (nonatomic, copy) NSString *nameContains;

@end
