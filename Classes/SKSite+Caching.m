//
//  SKSite+Caching.m
//  StackKit
//
//  Created by Dave DeLong on 1/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SKSite+Caching.h"


@implementation SKSite (Caching)

- (SKCache *) cacheForClass:(Class)aClass {
	SKCache *objectCache = [cache objectForKey:NSStringFromClass(aClass)];
	if (objectCache == nil) {
		objectCache = [[SKCache alloc] init];
		[cache setObject:objectCache forKey:NSStringFromClass(aClass)];
		[objectCache release];
	}
	return objectCache;
}

@end
