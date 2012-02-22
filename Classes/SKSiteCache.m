//
//  SKSiteCache.m
//  StackKit
//
//  Created by Dave DeLong on 2/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SKSiteCache.h"
#import <StackKit/SKConstants.h>
#import <StackKit/SKFunctions.h>
#import <StackKit/SKObject_Internal.h>
#import <StackKit/SKSite.h>
#import <StackKit/SKMacros.h>

static NSString *SKSiteCacheKeyDate = @"cacheDate";
static NSString *SKSiteCacheKeyObjects = @"objects";

@implementation SKSiteCache {
    dispatch_queue_t requestQueue;
    NSMutableArray *allSites;
    NSDate *lastFetchDate;
}

+ (id)sharedSiteCache {
    static dispatch_once_t onceToken;
    static SKSiteCache *sharedCache = nil;
    dispatch_once(&onceToken, ^{
        sharedCache = [[SKSiteCache alloc] init];
    });
    return sharedCache;
}

- (id)init {
    self = [super init];
    if (self) {
        allSites = [[NSMutableArray alloc] init];
        requestQueue = dispatch_queue_create("com.davedelong.stackkit.sksite", 0);
        dispatch_async(requestQueue, ^{
            [self _loadCachedSites];
        });
    }
    return self;
}

- (SKSite *)_constructSiteFromJSONDictionary:(NSDictionary *)d {
    REQUIRE_QUEUE(requestQueue);
    
    SKSite *site = [NSAllocateObject([SKSite class], 0, nil) _initWithInfo:d site:nil];
    return [site autorelease];
}

- (void)_loadCachedSites {
    REQUIRE_QUEUE(requestQueue);
    
    NSString *cacheFile = [self cacheFile];
    NSDictionary *d = [NSDictionary dictionaryWithContentsOfFile:cacheFile];
    NSDate *cacheDate = [d objectForKey:SKSiteCacheKeyDate];
    NSArray *sites = [d objectForKey:SKSiteCacheKeyObjects];
    
    if (cacheDate != nil && sites != nil) {
        [lastFetchDate release];
        lastFetchDate = [cacheDate retain];
        
        [allSites removeAllObjects];
        [allSites addObjectsFromArray:sites];
    }
}

- (NSString *)cacheFile {
    return [SKApplicationSupportDirectory() stringByAppendingPathComponent:@"sites.plist"];
}

- (void)_fetchSites:(NSError **)error {
    REQUIRE_QUEUE(requestQueue);
    // this function will:
    // 1. fetch all data from stackauth
    // 2. convert the json to SKSite objects
    // 3. cache the SKSite objects
    
    NSMutableArray *allItems = [NSMutableArray array];
    NSUInteger currentPage = 1;
    NSUInteger pageSize = 100;
    BOOL keepGoing = YES;
    
    while (keepGoing) {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        {
            NSMutableDictionary *query = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                          [NSNumber numberWithUnsignedInteger:currentPage], SKQueryKeys.page,
                                          [NSNumber numberWithUnsignedInteger:pageSize], SKQueryKeys.pageSize,
                                          nil];
            
            NSURL *requestURL = SKConstructAPIURL(@"sites", query);
            id response = SKExecuteAPICall(requestURL, error);
            if (SKExtractError(response, error)) {
                allItems = nil;
                break;
            }
            
            NSArray *items = [response objectForKey:SKAPIKeys.items];
            [allItems addObjectsFromArray:items];
            
            currentPage++;
            
            NSNumber *keepGoingNumber = [response objectForKey:SKAPIKeys.hasMore];
            keepGoing = [keepGoingNumber boolValue];
        }
        [pool drain];
    }
    
    [lastFetchDate release];
    lastFetchDate = [[NSDate date] retain];
    
    // 2: convert the json to SKSite objects
    for (NSDictionary *item in allItems) {
        SKSite *s = [self _constructSiteFromJSONDictionary:item];
        [allSites addObject:s];
    }
    
    NSDictionary *cacheData = [NSDictionary dictionaryWithObjectsAndKeys:
                               allSites, SKSiteCacheKeyObjects, 
                               lastFetchDate, SKSiteCacheKeyDate,
                               nil];
    [cacheData writeToFile:[self cacheFile] atomically:YES];
}

#pragma mark -

- (void)requestAllSitesWithCompletionHandler:(SKRequestHandler)handler {
    handler = [handler copy];
    dispatch_async(requestQueue, ^{
        NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
        NSTimeInterval cacheTime = [lastFetchDate timeIntervalSinceReferenceDate];
        
        // if our info is older than a day, toss it out
        if ((now - cacheTime) > 86400) {
            NSFileManager *fm = [[NSFileManager alloc] init];
            [fm removeItemAtPath:[self cacheFile] error:nil];
            [fm release];
            
            [allSites removeAllObjects];
            [lastFetchDate release], lastFetchDate = nil;
        }
        
        NSError *error = nil;
        if ([allSites count] == 0) {
            [self _fetchSites:&error];
        }
        
        NSArray *sites = nil;
        if (error == nil) {
            sites = [[allSites copy] autorelease];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(sites, error);
        });
    });
    [handler release];
}

@end
