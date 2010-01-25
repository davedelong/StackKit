//
//  SKUser.h
//  StackKit
//
//  Created by Dave DeLong on 1/25/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKObject.h"

@class SKSite;

@interface SKUser : SKObject {
	NSString * userID;
	NSString * displayName;
	NSURL * profileURL;
	NSUInteger reputation;
}

@property (readonly) NSString * userID;
@property (readonly) NSString * displayName;
@property (readonly) NSURL * profileURL;
@property (readonly) NSUInteger reputation;

- (id) initWithSite:(SKSite *)aSite userID:(NSString *)anID;

@end
