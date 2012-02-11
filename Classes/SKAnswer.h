//
//  SKAnswer.h
//  StackKit
//
//  Created by Dave DeLong on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <StackKit/SKObject.h>
#import <StackKit/SKPost.h>

@interface SKAnswer : SKObject <SKChildPost>

@property (readonly) NSString *title;
@property (readonly) BOOL isAccepted;

@property (readonly) NSUInteger upVoteCount;
@property (readonly) NSUInteger downVoteCount;

@property (readonly) NSDate *lockedDate;
@property (readonly) NSDate *lastEditDate;
@property (readonly) NSDate *lastActivityDate;
@property (readonly) NSDate *communityOwnedDate;

@end
