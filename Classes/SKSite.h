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

+ (void)requestSitesWithCompletionHandler:(SKSomething)handler;
+ (void)requestSiteWithNameLike:(NSString *)name completionHandler:(SKSiteHandler)handler;

@property (readonly) NSString *name;
@property (readonly) NSString *audience;
@property (readonly) NSDate *launchDate;
@property (readonly) SKSiteState siteState;

@property (readonly) NSURL *siteURL;
@property (readonly) NSURL *logoURL;
@property (readonly) NSURL *iconURL;
@property (readonly) NSURL *faviconURL;

- (void)executeFetchRequest:(SKFetchRequest *)request withCompletionHandler:(SKSomething)handler;


@end
