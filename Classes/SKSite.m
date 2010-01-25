//
//  SKSite.m
//  StackKit
//
//  Created by Dave DeLong on 1/25/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "SKSite.h"


@implementation SKSite

@synthesize siteURL;

- (id) initWithURL:(NSURL *)aURL {
	if (self = [super initWithSite:nil]) {
		siteURL = [aURL retain];
	}
	return self;
}

- (void) dealloc {
	[siteURL release];
	[super dealloc];
}

- (SKSite *) site {
	return [[self retain] autorelease];
}

@end
