// 
//  SKQAPost.m
//  StackKit
//
//  Created by Dave DeLong on 1/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SKQAPost.h"
#import "SKConstants_Internal.h"
#import "SKObject+Private.h"

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

@dynamic communityOwned;
@dynamic downVotes;
@dynamic lastActivityDate;
@dynamic lastEditDate;
@dynamic lockedDate;
@dynamic title;
@dynamic upVotes;
@dynamic viewCount;

@dynamic comments;

+ (NSDictionary *)APIAttributeToPropertyMapping {
    static NSDictionary *mapping = nil;
    if (!mapping) {
        mapping = [[super APIAttributeToPropertyMapping] mutableCopy];
        [(NSMutableDictionary *)mapping addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                  @"communityOwned", SKQAPostCommunityOwned,
                                                                  @"downVotes", SKQAPostDownVotes,
                                                                  @"lastActivityDate", SKQAPostLastActivityDate,
                                                                  @"lastEditDate", SKQAPostLastEditDate,
                                                                  @"lockedDate", SKQAPostLockedDate,
                                                                  @"title", SKQAPostTitle,
                                                                  @"upVotes", SKQAPostUpVotes,
                                                                  @"viewCount", SKQAPostViewCount,
                                                                  nil]];
    }
    return mapping;
}

@end
