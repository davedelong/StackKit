//
//  SKQAPost.m
//  StackKit
//
//  Created by Dave DeLong on 1/25/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "StackKit_Internal.h"

NSString * const SKQAPostLockedDate = @"locked_date";
NSString * const SKQAPostLastEditDate = @"last_edit_date";
NSString * const SKQAPostLastActivityDate = @"last_activity_date";
NSString * const SKQAPostUpVotes = @"up_vote_count";
NSString * const SKQAPostDownVotes = @"down_vote_count";
NSString * const SKQAPostViewCount = @"view_count";
NSString * const SKQAPostCommunityOwned = @"community_owned";
NSString * const SKQAPostTitle = @"title";

@implementation SKQAPost

@synthesize lockedDate;
@synthesize lastEditDate;
@synthesize lastActivityDate;
@synthesize upVotes;
@synthesize downVotes;
@synthesize viewCount;
@synthesize communityOwned;
@synthesize title;

+ (NSDictionary *) APIAttributeToPropertyMapping {
	return [NSDictionary dictionaryWithObjectsAndKeys:
			@"lockedDate", SKQAPostLockedDate,
			@"lastEditDate", SKQAPostLastEditDate,
			@"lastActivityDate", SKQAPostLastActivityDate,
			@"upVotes", SKQAPostUpVotes,
			@"downVotes", SKQAPostDownVotes,
			@"viewCount", SKQAPostViewCount,
			@"communityOwned", SKQAPostCommunityOwned,
			nil];
}

- (id) initWithSite:(SKSite *)aSite dictionaryRepresentation:(NSDictionary *)dictionary {
	if (self = [super initWithSite:aSite dictionaryRepresentation:dictionary]) {
		lockedDate = [[dictionary objectForKey:SKQAPostLockedDate] retain];
		lastEditDate = [[dictionary objectForKey:SKQAPostLastEditDate] retain];
		lastActivityDate = [[dictionary objectForKey:SKQAPostLastActivityDate] retain];
		upVotes = [[dictionary objectForKey:SKQAPostUpVotes] retain];
		downVotes = [[dictionary objectForKey:SKQAPostDownVotes] retain];
		viewCount = [[dictionary objectForKey:SKQAPostViewCount] retain];
		communityOwned = [[dictionary objectForKey:SKQAPostCommunityOwned] retain];
	}
	return self;
}

- (void) dealloc {
	[lockedDate release];
	[lastEditDate release];
	[lastActivityDate release];
	[upVotes release];
	[downVotes release];
	[viewCount release];
	[communityOwned release];
	[super dealloc];
}

@end
