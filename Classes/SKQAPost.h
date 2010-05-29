//
//  SKQAPost.h
//  StackKit
//
//  Created by Dave DeLong on 1/25/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKPost.h"

extern NSString * const SKQAPostLockedDate;
extern NSString * const SKQAPostLastEditDate;
extern NSString * const SKQAPostLastActivityDate;
extern NSString * const SKQAPostUpVotes;
extern NSString * const SKQAPostDownVotes;
extern NSString * const SKQAPostViewCount;
extern NSString * const SKQAPostCommunityOwned;
extern NSString * const SKQAPostTitle;

@interface SKQAPost : SKPost {
	NSDate * lockedDate;
	NSDate * lastEditDate;
	NSDate * lastActivityDate;
	NSNumber * upVotes;
	NSNumber * downVotes;
	NSNumber * viewCount;
	NSNumber * communityOwned;
	NSString * title;
}

@property (readonly) NSDate * lockedDate;
@property (readonly) NSDate * lastEditDate;
@property (readonly) NSDate * lastActivityDate;
@property (readonly) NSNumber * upVotes;
@property (readonly) NSNumber * downVotes;
@property (readonly) NSNumber * viewCount;
@property (readonly) NSNumber * communityOwned;
@property (readonly) NSString * title;

@end
