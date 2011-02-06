//
//  SKQAPost.h
//  StackKit
//
//  Created by Dave DeLong on 1/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "SKPost.h"

//inherited
extern NSString * const SKQAPostCreationDate;
extern NSString * const SKQAPostOwner;
extern NSString * const SKQAPostBody;
extern NSString * const SKQAPostScore;

extern NSString * const SKQAPostCommunityOwned;
extern NSString * const SKQAPostDownVotes;
extern NSString * const SKQAPostLastActivityDate;
extern NSString * const SKQAPostLastEditDate;
extern NSString * const SKQAPostLockedDate;
extern NSString * const SKQAPostTitle;
extern NSString * const SKQAPostUpVotes;
extern NSString * const SKQAPostViewCount;

@interface SKQAPost : SKPost  
{
}

@property (nonatomic, readonly) NSNumber * communityOwned;
@property (nonatomic, readonly) NSNumber * downVotes;
@property (nonatomic, readonly) NSDate * lastActivityDate;
@property (nonatomic, readonly) NSDate * lastEditDate;
@property (nonatomic, readonly) NSDate * lockedDate;
@property (nonatomic, readonly) NSString * title;
@property (nonatomic, readonly) NSNumber * upVotes;
@property (nonatomic, readonly) NSNumber * viewCount;

@property (nonatomic, readonly) NSSet* comments;

@end

