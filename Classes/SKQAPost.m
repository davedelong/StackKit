// 
//  SKQAPost.m
//  StackKit
//
//  Created by Dave DeLong on 1/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SKQAPost.h"
#import "SKConstants_Internal.h"

//inherited
NSString * const SKQAPostCreationDate = __SKPostCreationDate;
NSString * const SKQAPostOwner = __SKPostOwner;
NSString * const SKQAPostBody = __SKPostBody;
NSString * const SKQAPostScore = __SKPostScore;

NSString * const SKQAPostCommunityOwned = __SKQAPostCommunityOwned;
NSString * const SKQAPostDownVotes = __SKQAPostDownVotes;
NSString * const SKQAPostLastActivityDate = __SKQAPostLastActivityDate;
NSString * const SKQAPostLastEditDate = __SKQAPostLastEditDate;
NSString * const SKQAPostLockedDate = __SKQAPostLockedDate;
NSString * const SKQAPostTitle = __SKQAPostTitle;
NSString * const SKQAPostUpVotes = __SKQAPostUpVotes;
NSString * const SKQAPostViewCount = __SKQAPostViewCount;

@implementation SKQAPost 

SK_GETTER(NSNumber *, communityOwned);
SK_GETTER(NSNumber *, downVotes);
SK_GETTER(NSDate *, lastActivityDate);
SK_GETTER(NSDate *, lastEditDate);
SK_GETTER(NSDate *, lockedDate);
SK_GETTER(NSString *, title);
SK_GETTER(NSNumber *, upVotes);
SK_GETTER(NSNumber *, viewCount);

SK_GETTER(NSSet*, comments);

@end
