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

@end

@interface SKUserFetchRequest : SKFetchRequest

- (id)createdSince:(NSDate *)date;
- (id)createdBefore:(NSDate *)date;

- (id)sortedByCreationDate;
- (id)sortedByName;
- (id)sortedByReputation;
- (id)sortedByLastModifiedDate;

- (id)whoseDisplayNameContains:(NSString *)name;

@end
