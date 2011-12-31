//
//  SKSite.m
//  StackKit
//
//  Created by Dave DeLong on 12/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SKSite.h"
#import <StackKit/StackKit_Internal.h>
#import <CoreData/CoreData.h>

dispatch_queue_t SKSiteQueue();

static NSArray *SKGetSites(NSError **error);

static NSMutableArray *SKSites();
void SKFetchSites(NSError **error);

static NSString *SKSiteCacheKeyDate = @"cacheDate";
static NSString *SKSiteCacheKeyObjects = @"objects";
NSString* SKSiteCachePath();
NSArray* SKGetCachedSites();
void SKSetCachedSites(NSArray *sitesJSON);

@interface SKSite()

-(NSURL *)dataModelURL;

@property (nonatomic, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation SKSite

@dynamic name;
@dynamic audience;
@dynamic launchDate;

@dynamic logoURL;
@dynamic siteURL;
@dynamic iconURL;
@dynamic faviconURL;

@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (void)requestSitesWithCompletionHandler:(SKSomething)handler errorHandler:(SKErrorHandler)error {
    handler = [handler copy];
    error = [error copy];
    
    dispatch_async(SKSiteQueue(), ^{
        
        NSError *err = nil;
        NSArray *result = SKGetSites(&err);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (err != nil) {
                error(err);
            } else {
                handler(result);
            }
        });
    });
    
    [error release];
    [handler release];
}

+ (void)requestSiteWithNameLike:(NSString *)name completionHandler:(SKSiteHandler)handler errorHandler:(SKErrorHandler)error {
    handler = [handler copy];
    
    NSArray *words = [name componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    SKSomething block = ^(NSArray *sites) {
        // this will be called on the main thread
        NSPredicate *template = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] $word OR audience CONTAINS[cd] $word or siteURL.absoluteString CONTAINS[cd] $word"];
        
        for (NSString *word in words) {
            if ([word length] == 0) { continue; }
            NSPredicate *p = [template predicateWithSubstitutionVariables:[NSDictionary dictionaryWithObject:word forKey:@"word"]];
            sites = [sites filteredArrayUsingPredicate:p];
        }
        
        SKSite *match = nil;
        if ([sites count] > 0) {
            match = [sites objectAtIndex:0];
        }
        
        handler(match);
    };
    
    [SKSite requestSitesWithCompletionHandler:block errorHandler:error];
    
    [handler release];
}

#pragma mark -
#pragma mark SKSite Instance Stuff

+ (NSArray *)APIKeysBackingProperties {
    static dispatch_once_t onceToken;
    static NSArray *array = nil;
    dispatch_once(&onceToken, ^{
        array = [[NSArray alloc] initWithObjects:
                 SKResponseKeys.site.name,
                 SKResponseKeys.site.audience,
                 SKResponseKeys.site.launchDate,
                 SKResponseKeys.site.logoURL,
                 SKResponseKeys.site.siteURL,
                 SKResponseKeys.site.iconURL,
                 SKResponseKeys.site.faviconURL,
                 SKResponseKeys.site.siteState,
                 nil];
    });
    return array;
}

+ (NSDictionary *)APIToObjectMappping {
    static dispatch_once_t onceToken;
    static NSDictionary *map = nil;
    dispatch_once(&onceToken, ^{
        NSArray *apiKeys = [self APIKeysBackingProperties];
        NSMutableDictionary *d = [[NSMutableDictionary alloc] init];
        for (NSString *apiKey in apiKeys) {
            NSString *propertyName = SKInferPropertyNameFromAPIKey(apiKey);
            [d setObject:propertyName forKey:apiKey];
        }
        map = [d copy];
        [d release];
    });
    return map;
}

+ (NSDictionary *)objectToAPIMapping {
    static dispatch_once_t onceToken;
    static NSDictionary *map = nil;
    dispatch_once(&onceToken, ^{
        NSDictionary *otherMap = [self APIToObjectMappping];
        NSArray *keys = [otherMap allKeys];
        NSArray *values = [otherMap objectsForKeys:keys notFoundMarker:[NSNull null]];
        
        // the keys from the other map become the objects in this map
        map = [[NSDictionary alloc] initWithObjects:keys forKeys:values];
    });
    return map;
}

- (void)dealloc {
    [_managedObjectModel release];
    [_managedObjectContext release];
    [_persistentStoreCoordinator release];
    [super dealloc];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ {name = %@, url = %@}", 
            [super description],
            [self name],
            [self siteURL]];
}

+ (NSString *)_infoKeyForSelector:(SEL)selector {
    return [[self objectToAPIMapping] objectForKey:NSStringFromSelector(selector)];
}

+ (id)_transformValue:(id)value forReturnType:(Class)returnType {
    if (returnType == [NSURL class]) {
        value = [NSURL URLWithString:value];
    } else if (returnType == [NSDate class]) {
        value = [NSDate dateWithTimeIntervalSince1970:[value doubleValue]];
    }
    
    return value;
}

// this has a non-object return type, so we'll override the getter manually
- (SKSiteState)siteState {
    NSString *value = [self _valueForInfoKey:SKResponseKeys.site.siteState];
    SKSiteState s = SKSiteStateNormal;

    if ([value isEqualToString:@"linked_meta"]) {
        s = SKSiteStateLinkedMeta;
    } else if ([value isEqualToString:@"open_beta"]) {
        s = SKSiteStateOpenBeta;
    } else if ([value isEqualToString:@"closed_beta"]) {
        s = SKSiteStateClosedBeta;
    }
    return s;
}

#pragma mark Core Data stack

- (NSURL *)dataModelURL {
    return [SKBundle() URLForResource:@"StackKit" withExtension:@"momd"];
}

- (NSManagedObjectModel *)managedObjectModel {
    if(_managedObjectModel == nil) {
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:[self dataModelURL]];
    }
    return _managedObjectModel;
}

- (NSManagedObjectContext *)managedObjectContext {
    if(_managedObjectContext == nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:[self persistentStoreCoordinator]];
    }
    
    return _managedObjectContext;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if(_persistentStoreCoordinator == nil) {
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];

        NSError *error = nil;
        [_persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType
                                                  configuration:nil
                                                            URL:nil
                                                        options:nil
                                                          error:&error];
        if(error != nil) {
            NSLog(@"Cannot add the in-memory store type to the persistent store coordinator (%@), error: %@", _persistentStoreCoordinator, [error localizedDescription]);
            
            [_persistentStoreCoordinator release];
            _persistentStoreCoordinator = nil;
        }
    }
    
    return _persistentStoreCoordinator;
}

@end

static NSArray *SKGetSites(NSError **error) {
    if ([SKSites() count] == 0) {
        SKFetchSites(error);
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

void SKFetchSites(NSError **error) {
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
            id response = SKExecuteAPICall(requestURL, error);
            if (SKExtractError(response, error)) {
                allItems = nil;
                break;
            }
            
            NSArray *items = [response objectForKey:SKResponseKeys.items];
            [allItems addObjectsFromArray:items];
            
            currentPage++;
            
            NSNumber *keepGoingNumber = [response objectForKey:SKResponseKeys.hasMore];
            keepGoing = [keepGoingNumber boolValue];
        }
        [pool release];
    }
    
    // 2: cache the json
    if (allItems) {
        SKSetCachedSites(allItems);
    }
    
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
