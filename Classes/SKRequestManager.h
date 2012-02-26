//
//  SKRequestManager.h
//  StackKit
//
//  Created by Dave DeLong on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StackKit/SKTypes.h>

@class SKFetchRequest;

@interface SKRequestManager : NSObject

@property (nonatomic) BOOL shouldCacheDataLocally;

+ (id)requestManagerWithSite:(SKSite *)site;

- (void)executeRequest:(SKFetchRequest *)request asynchronously:(BOOL)async completionHandler:(SKRequestHandler)handler;

@end
