//
//  SKSiteManager.h
//  StackKit
//
//  Created by Alex Rozanski on 12/02/2011.
//  Copyright 2011 Alex Rozanski. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SKSite;

@interface SKSiteManager : NSObject {
    NSMutableArray *_knownSites;
}

+ (id)sharedManager;

- (NSArray *) knownSites;

- (SKSite*) siteWithAPIURL:(NSURL *)aURL;

- (SKSite*) stackOverflowSite;
- (SKSite*) metaStackOverflowSite;
- (SKSite*) stackAppsSite;
- (SKSite*) serverFaultSite;
- (SKSite*) superUserSite;


@end
