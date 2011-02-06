//
//  SKPost.h
//  StackKit
//
//  Created by Dave DeLong on 1/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "SKObject.h"

extern NSString * const SKPostBody;
extern NSString * const SKPostCreationDate;
extern NSString * const SKPostOwner;
extern NSString * const SKPostScore;

@class SKUser;

@interface SKPost : SKObject  
{
}

@property (nonatomic, readonly) NSString * body;
@property (nonatomic, readonly) NSDate * creationDate;
@property (nonatomic, readonly) NSNumber * score;
@property (nonatomic, readonly) NSNumber * postID;
@property (nonatomic, readonly) SKUser * owner;
@property (nonatomic, readonly) NSSet* postActivity;

@end

