//
//  SKQAPost.m
//  StackKit
//
//  Created by Dave DeLong on 1/25/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "StackKit_Internal.h"

@interface SKQAPost ()

- (void) loadVotes;

@end


@implementation SKQAPost

@synthesize voteCount;

- (void) loadJSON:(NSDictionary *)jsonDictionary {
	[super loadJSON:jsonDictionary];
	if ([jsonDictionary objectForKey:@"VoteCount"] != nil) {
		voteCount = [[jsonDictionary objectForKey:@"VoteCount"] unsignedIntegerValue];
	}
	if ([jsonDictionary objectForKey:@"up"] != nil) {
		upVotes = [[jsonDictionary objectForKey:@"up"] unsignedIntegerValue];
	}
	if ([jsonDictionary objectForKey:@"down"] != nil) {
		downVotes = [[jsonDictionary objectForKey:@"down"] unsignedIntegerValue];
	}
}

- (NSUInteger) upVotes {
	if (_votesLoaded == NO) {
		[self loadVotes];
	}
	return upVotes;
}

- (NSUInteger) downVotes {
	if (_votesLoaded == NO) {
		[self loadVotes];
	}
	return downVotes;
}

#pragma mark -
#pragma mark Private Methods

- (void) loadVotes {
	NSString * path = [NSString stringWithFormat:@"/posts/%@/vote-counts", [self postID]];
	NSURL * url = [NSURL URLWithString:path relativeToURL:[[self site] siteURL]];
	
	NSDictionary * json = [self jsonObjectAtURL:url];
	if (json == nil) {
		NSLog(@"Error loading votes");
		return;
	}
	
	[self loadJSON:json];
	_votesLoaded = YES;
}

@end
