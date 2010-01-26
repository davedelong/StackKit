//
//  SKQAPost.h
//  StackKit
//
//  Created by Dave DeLong on 1/25/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKPost.h"

@interface SKQAPost : SKPost {
	BOOL _votesLoaded;
	NSUInteger upVotes;
	NSUInteger downVotes;
	
	NSUInteger voteCount;
}

@property (readonly) NSUInteger upVotes;
@property (readonly) NSUInteger downVotes;
@property (readonly) NSUInteger voteCount;

@end
