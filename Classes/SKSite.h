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

+ (void)requestSitesWithCompletionHandler:(SKSomething)handler errorHandler:(SKErrorHandler)error;
+ (void)requestSiteWithNameLike:(NSString *)name completionHandler:(SKSiteHandler)handler errorHandler:(SKErrorHandler)error;

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *audience;
@property (nonatomic, readonly) NSDate *launchDate;
@property (nonatomic, readonly) SKSiteState siteState;

@property (nonatomic, readonly) NSURL *siteURL;
@property (nonatomic, readonly) NSURL *logoURL;
@property (nonatomic, readonly) NSURL *iconURL;
@property (nonatomic, readonly) NSURL *faviconURL;

- (void)executeFetchRequest:(SKFetchRequest *)request withCompletionHandler:(SKSomething)handler errorHandler:(SKErrorHandler)errorHandler;


@end
