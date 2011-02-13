//
//  SKSiteManager.h
//  StackKit
//
//  Created by Alex Rozanski on 12/02/2011.
//  Copyright 2011 Alex Rozanski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKDefinitions.h"

@class SKSite;
@class SKUser;

@interface SKSiteManager : NSObject {
    dispatch_queue_t _knownSitesQueue;
    NSMutableArray *_knownSites;
    NSOperationQueue *stackAuthQueue;
}

+ (id)sharedManager;

- (NSArray *) knownSites;

- (SKSite*) siteWithAPIURL:(NSURL *)aURL;

- (SKSite*) stackOverflowSite;
- (SKSite*) metaStackOverflowSite;
- (SKSite*) stackAppsSite;
- (SKSite*) serverFaultSite;
- (SKSite*) superUserSite;

- (void) requestAssociatedUsersForUser:(SKUser *)user completionHandler:(SKRequestHandler)handler;

@end
