//
//  SKSite.h
//  StackKit
//
//  Created by Dave DeLong on 12/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <StackKit/SKTypes.h>
#import <StackKit/SKObject.h>

@class SKFetchRequest;

@interface SKSite : SKObject

+ (void)requestSitesWithCompletionHandler:(SKRequestHandler)handler;
+ (void)requestSiteWithNameLike:(NSString *)name completionHandler:(SKSiteHandler)handler;
+ (void)requestSitesWithNames:(NSArray *)names completionHandler:(SKRequestHandler)handler;

@property BOOL cachesDataLocally;

@property (readonly) NSString *name;
@property (readonly) NSString *audience;
@property (readonly) NSDate *launchDate;
@property (readonly) SKSiteState siteState;

@property (readonly) NSURL *siteURL;
@property (readonly) NSURL *logoURL;
@property (readonly) NSURL *iconURL;
@property (readonly) NSURL *faviconURL;

- (void)executeFetchRequest:(SKFetchRequest *)request completionHandler:(SKRequestHandler)handler;


@end
