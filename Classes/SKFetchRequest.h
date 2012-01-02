//
//  SKFetchRequest.h
//  StackKit
//
//  Created by Dave DeLong on 12/31/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SKUserFetchRequest;

@interface SKFetchRequest : NSObject

+ (SKUserFetchRequest *)requestForFetchingUsers;

- (id)inAscendingOrder;
- (id)inDescendingOrder;

@end

@interface SKUserFetchRequest : SKFetchRequest

- (id)createdAfter:(NSDate *)date;
- (id)createdBefore:(NSDate *)date;

- (id)sortedByCreationDate;
- (id)sortedByName;
- (id)sortedByReputation;
- (id)sortedByLastModifiedDate;

- (id)whoseDisplayNameContains:(NSString *)name;
- (id)withIDs:(NSUInteger)userID,... NS_REQUIRES_NIL_TERMINATION;

@end
