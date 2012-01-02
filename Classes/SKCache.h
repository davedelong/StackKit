//
//  SKCache.h
//  StackKit
//
//  Created by Dave DeLong on 1/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKCache : NSObject

+ (id)cacheWithStrongToWeakObjects;
+ (id)cacheWithWeakToWeakObjects;

- (void)cacheObject:(id)object forKey:(id)key;
- (id)cachedObjectForKey:(id)key;

@end
