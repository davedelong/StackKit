//
//  SKPost.h
//  StackKit
//
//  Created by Dave DeLong on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StackKit/SKTypes.h>

@protocol SKPost <NSObject>

@required
@property (readonly) NSUInteger postID;
@property (readonly) SKPostType postType;

@property (readonly) NSString *body;
@property (readonly) NSDate *creationDate;
@property (readonly) NSUInteger ownerID;
@property (readonly) NSUInteger score;

@end

@protocol SKChildPost <SKPost>

@required
@property (readonly) NSUInteger parentPostID;
@property (readonly) SKPostType parentPostType;

@end
