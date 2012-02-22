//
//  SKSiteCache.h
//  StackKit
//
//  Created by Dave DeLong on 2/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StackKit/SKTypes.h>

@interface SKSiteCache : NSObject

+ (id)sharedSiteCache;

- (void)requestAllSitesWithCompletionHandler:(SKRequestHandler)handler;

@end
