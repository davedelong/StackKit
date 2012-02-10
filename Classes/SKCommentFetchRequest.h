//
//  SKCommentFetchRequest.h
//  StackKit
//
//  Created by Dave DeLong on 2/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <StackKit/SKFetchRequest_Internal.h>

@interface SKCommentFetchRequest ()

@property (nonatomic, retain) NSMutableIndexSet *commentIDs;
@property (nonatomic, retain) NSMutableIndexSet *postIDs;
@property (nonatomic, retain) NSMutableIndexSet *userIDs;
@property (nonatomic, retain) NSMutableIndexSet *replyIDs;

@end
