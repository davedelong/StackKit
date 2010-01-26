//
//  SKPost.h
//  StackKit
//
//  Created by Dave DeLong on 1/25/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKObject.h"

@class SKUser;

@interface SKPost : SKObject {
	NSNumber * postID;
	NSDate * creationDate;
	NSDate * modifiedDate;
	SKUser * author;
}

@property (readonly) NSNumber * postID;
@property (readonly) NSDate * creationDate;
@property (readonly) NSDate * modifiedDate;
@property (readonly) SKUser * author;

- (id) initWithSite:(SKSite *)aSite json:(NSDictionary *)json;
- (id) initWithSite:(SKSite *)aSite postID:(NSNumber *)anID;

@end
