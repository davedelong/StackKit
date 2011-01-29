//
//  SKQAPost+Private.m
//  StackKit
//
//  Created by Dave DeLong on 1/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SKQAPost+Private.h"
#import "SKObject+Private.h"
#import "SKQAPost+Public.h"

@implementation SKQAPost (Private)

@dynamic upVotes;
@dynamic title;
@dynamic lastActivityDate;
@dynamic lastEditDate;
@dynamic downVotes;
@dynamic lockedDate;
@dynamic viewCount;
@dynamic communityOwned;
@dynamic comments;

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

- (void) mergeInformationFromDictionary:(NSDictionary *)dictionary {
	[super mergeInformationFromDictionary:dictionary];
	[self setLockedDate:[NSDate dateWithTimeIntervalSince1970:[[dictionary objectForKey:SKQAPostLockedDate] doubleValue]]];
	[self setLastEditDate:[NSDate dateWithTimeIntervalSince1970:[[dictionary objectForKey:SKQAPostLastEditDate] doubleValue]]];
	[self setLastActivityDate:[NSDate dateWithTimeIntervalSince1970:[[dictionary objectForKey:SKQAPostLastActivityDate] doubleValue]]];
	[self setUpVotes:[dictionary objectForKey:SKQAPostUpVotes]];
	[self setDownVotes:[dictionary objectForKey:SKQAPostDownVotes]];
	[self setViewCount:[dictionary objectForKey:SKQAPostViewCount]];
	[self setCommunityOwned:[dictionary objectForKey:SKQAPostCommunityOwned]];
	[self setTitle:[dictionary objectForKey:SKQAPostTitle]];
	
	//TODO: merge comments
}

@end
