//
//  SKQAPost.h
//  StackKit
//
//  Created by Dave DeLong on 1/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "SKPost.h"

@class SKComment;

@interface SKQAPost : SKPost  
{
}

@property (nonatomic, retain, readonly) NSNumber * upVotes;
@property (nonatomic, retain, readonly) NSString * title;
@property (nonatomic, retain, readonly) NSDate * lastActivityDate;
@property (nonatomic, retain, readonly) NSDate * lastEditDate;
@property (nonatomic, retain, readonly) NSNumber * downVotes;
@property (nonatomic, retain, readonly) NSDate * lockedDate;
@property (nonatomic, retain, readonly) NSNumber * viewCount;
@property (nonatomic, retain, readonly) NSNumber * communityOwned;
@property (nonatomic, retain, readonly) NSSet* comments;

@end

