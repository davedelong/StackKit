//
//  SKCache.h
//  StackKit
//
//  Created by Dave DeLong on 2/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SKCache : NSObject <NSCacheDelegate> {
	NSCache *cache;
	NSMutableSet *objects;
}

- (id) init;
- (void) setObject:(id)object forKey:(id)key;
- (void) removeObjectForKey:(id)key;
- (id) objectForKey:(id)key;
- (NSArray *) allObjects;

@end
