//
//  SKPost+Private.h
//  StackKit
//
//  Created by Dave DeLong on 1/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKPost.h"

@class SKUser;

@interface SKPost (Private)

@property (nonatomic, retain) NSString * body;
@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) NSNumber * postID;
@property (nonatomic, retain) SKUser * owner;
@property (nonatomic, retain) NSSet* postActivity;

@end


@interface SKPost (CoreDataGeneratedAccessors)
- (void)addPostActivityObject:(SKUserActivity *)value;
- (void)removePostActivityObject:(SKUserActivity *)value;
- (void)addPostActivity:(NSSet *)value;
- (void)removePostActivity:(NSSet *)value;

@end
