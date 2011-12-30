//
//  SKSite.m
//  StackKit
//
//  Created by Dave DeLong on 12/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SKSite.h"
#import <StackKit/StackKit_Internal.h>

dispatch_queue_t SKSiteQueue();

static NSArray *SKGetSites();

static NSMutableArray *SKSites();
void SKFetchSites();

static NSString *SKSiteCacheKeyDate = @"cacheDate";
static NSString *SKSiteCacheKeyObjects = @"objects";
NSString* SKSiteCachePath();
NSArray* SKGetCachedSites();
void SKSetCachedSites(NSArray *sitesJSON);

@implementation SKSite

+ (void)requestSitesWithCompletionHandler:(SKSomething)handler {
    handler = [handler copy];
    
    dispatch_async(SKSiteQueue(), ^{
        
        NSArray *result = SKGetSites();
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(result);
        });
    });
    
    [handler release];
}

#pragma mark -
#pragma mark SKSite Instance Stuff

+ (id)allocWithZone:(NSZone *)zone {
    [NSException raise:NSInternalInconsistencyException format:@"You may not allocate an SKSite object"];
    return nil;
}

- (id)_initWithInfo:(NSDictionary *)info {
    self = [super init];
    if (self) {
        SKLog(@"info: %@", info);
    }
    return self;
}

@end

static NSArray *SKGetSites() {
    if ([SKSites() count] == 0) {
        SKFetchSites();
    }
    
    return [[SKSites() copy] autorelease];
}

dispatch_queue_t SKSiteQueue() {
    static dispatch_once_t onceToken;
    static dispatch_queue_t siteQueue;
    dispatch_once(&onceToken, ^{
        siteQueue = dispatch_queue_create("com.davedelong.stackkit.sksite", 0);
    });
    return siteQueue;
}

NSMutableArray *SKSites() {
    static dispatch_once_t onceToken;
    static NSMutableArray *sites = nil;
    dispatch_once(&onceToken, ^{
        sites = [[NSMutableArray alloc] init];
    });
    return sites;
}

NSString* SKSiteCachePath() {
    return [SKApplicationSupportDirectory() stringByAppendingPathComponent:@"sites.plist"];
}

NSArray* SKGetCachedSites() {
    NSString *cacheFile = SKSiteCachePath();
    NSDictionary *d = [NSDictionary dictionaryWithContentsOfFile:cacheFile];
    NSDate *cacheDate = [d objectForKey:SKSiteCacheKeyDate];
    
    NSTimeInterval cacheInterval = [cacheDate timeIntervalSinceReferenceDate];
    NSTimeInterval nowInterval = [NSDate timeIntervalSinceReferenceDate];
    
    // go with approximately a day
    if (fabs(cacheInterval - nowInterval) > 86400) {
        d = nil;
    }
    
    return [d objectForKey:SKSiteCacheKeyObjects];
}

void SKSetCachedSites(NSArray *sitesJSON) {
    NSDictionary *d = [NSDictionary dictionaryWithObjectsAndKeys:
                       sitesJSON, SKSiteCacheKeyObjects,
                       [NSDate date], SKSiteCacheKeyDate, 
                       nil];
    
    [d writeToFile:SKSiteCachePath() atomically:YES];
}

void SKFetchSites() {
    // this function will:
    // 1. fetch all data from stackauth
    // 2. cache the json
    // 3. convert the json to SKSite objects
    // 4. save the SKSite objects into the SKSites() array
    
    NSMutableArray *allItems = [NSMutableArray array];
    NSUInteger currentPage = 1;
    NSUInteger pageSize = 100;
    BOOL keepGoing = YES;
    
    while (keepGoing) {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        {
            NSMutableDictionary *query = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                          [NSNumber numberWithUnsignedInteger:currentPage], SKQueryParameters.page,
                                          [NSNumber numberWithUnsignedInteger:pageSize], SKQueryParameters.pageSize,
                                          nil];
            
            NSURL *requestURL = SKConstructAPIURL(@"sites", query);
            NSURLRequest *request = [NSURLRequest requestWithURL:requestURL];
            
            NSURLResponse * response = nil;
            NSError * connectionError = nil;
            NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&connectionError];
            
            NSDictionary *responseObjects = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if ([responseObjects isKindOfClass:[NSDictionary class]] == NO) {
                allItems = nil;
                break;
            }
            
            NSArray *items = [responseObjects objectForKey:@"items"];
            [allItems addObjectsFromArray:items];
            
            currentPage++;
            
            NSNumber *keepGoingNumber = [responseObjects objectForKey:@"has_more"];
            keepGoing = [keepGoingNumber boolValue];
        }
        [pool release];
    }
    
    // 2: cache the json
    SKSetCachedSites(allItems);
    
    // 3: convert the json to SKSite objects
    NSMutableArray *sites = SKSites();
    for (NSDictionary *item in allItems) {
        SKSite *site = NSAllocateObject([SKSite class], 0, nil);
        [site _initWithInfo:item];
        
        // 4: save the SKSites into the SKSites() array
        [sites addObject:site];
        [site release];
    }
}
