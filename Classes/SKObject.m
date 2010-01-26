//
//  SKObject.m
//  StackKit
//
//  Created by Dave DeLong on 1/25/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "StackKit_Internal.h"

@implementation SKObject

- (id) initWithSite:(SKSite *)aSite {
	if (self = [super init]) {
		site = aSite;
	}
	return self;
}

- (SKSite *) site {
	return [[site retain] autorelease];
}

- (void) loadJSON:(NSDictionary *)jsonDictionary {
	return;
}

@end
