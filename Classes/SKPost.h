//
//  SKPost.h
//  StackKit
//
//  Created by Dave DeLong on 1/25/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKObject.h"

extern NSString * const SKPostCreationDate;
extern NSString * const SKPostOwner;
extern NSString * const SKPostBody;
extern NSString * const SKPostScore;

typedef enum {
	SKPostTypeQuestion = 0,
	SKPostTypeAnswer = 1
} SKPostType_t;

@class SKUser;

@interface SKPost : SKObject {
	NSNumber * ownerID;
	NSDate * creationDate;
	NSString * body;
	NSNumber * score;
}

@property (readonly) NSDate * creationDate;
@property (readonly) NSNumber * ownerID;
@property (readonly) NSString * body;
@property (readonly) NSNumber * score;

- (SKUser *)owner;

@end
