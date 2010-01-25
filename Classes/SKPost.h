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
	NSString * postID;
	NSDate * timestamp;
	SKUser * author;
}

@property (readonly) NSString * postID;
@property (readonly) NSDate * timestamp;
@property (readonly) SKUser * author;

@end
