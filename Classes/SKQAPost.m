//
//  SKQAPost.m
//  StackKit
/**
 Copyright (c) 2010 Dave DeLong
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 **/

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
