//
//  SKComment.h
//  StackKit
//
//  Created by Dave DeLong on 2/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <StackKit/SKObject.h>
#import <StackKit/SKTypes.h>
#import <StackKit/SKPost.h>

@interface SKComment : SKObject <SKChildPost>

@property (readonly) BOOL edited;
@property (readonly) NSUInteger inReplyToUserID;

@end
