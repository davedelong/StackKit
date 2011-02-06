//
//  SKSite+Caching.h
//  StackKit
//
//  Created by Dave DeLong on 1/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKSite.h"
#import "SKCache.h"

@interface SKSite (Caching)

- (SKCache *) cacheForClass:(Class)aClass;

@end
