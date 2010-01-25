//
//  SKObject.m
//  StackKit
//
//  Created by Dave DeLong on 1/25/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "SKObject.h"


@implementation SKObject

- (id) initWithSite:(SKSite *)aSite {
	if (self = [super init]) {
		site = [aSite retain];
	}
	return self;
}

- (void) dealloc {
	[site release];
	[super dealloc];
}

- (SKSite *) site {
	return [[site retain] autorelease];
}

@end
