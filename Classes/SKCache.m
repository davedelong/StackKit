//
//  SKCache.m
//  StackKit
//
//  Created by Dave DeLong on 2/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SKCache.h"


@implementation SKCache

- (id) init {
	self = [super init];
	if (self) {
		cache = [[NSCache alloc] init];
		[cache setDelegate:self];
		
		objects = [[NSMutableSet alloc] init];
	}
	return self;
}

- (void) setObject:(id)object forKey:(id)key {
	[cache setObject:object forKey:key];
	[objects addObject:key];
}

- (void) removeObjectForKey:(id)key {
	id obj = [cache objectForKey:key];
	if (obj) {
		[objects removeObject:obj];
	}
	[cache removeObjectForKey:key];
}

- (id) objectForKey:(id)key {
	return [cache objectForKey:key];
}

- (NSArray *) allObjects {
	return [objects allObjects];
}

#pragma mark -

- (void) cache:(NSCache *)cache willEvictObject:(id)obj {
	[objects removeObject:obj];
}

@end
