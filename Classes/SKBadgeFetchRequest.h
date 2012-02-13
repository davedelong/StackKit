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

@property (readonly) NSMutableIndexSet *userIDs;
@property (readonly) NSMutableIndexSet *badgeIDs;
@property (readonly) _SKBadgeType requestedType;
@property (copy) NSString *nameContains;

@end
