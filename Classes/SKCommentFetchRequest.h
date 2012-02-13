//
//  SKCommentFetchRequest.h
//  StackKit
//
//  Created by Dave DeLong on 2/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <StackKit/SKFetchRequest_Internal.h>

@interface SKCommentFetchRequest ()

@property (readonly) NSMutableIndexSet *commentIDs;
@property (readonly) NSMutableIndexSet *postIDs;
@property (readonly) NSMutableIndexSet *userIDs;
@property (readonly) NSMutableIndexSet *replyIDs;

@end
