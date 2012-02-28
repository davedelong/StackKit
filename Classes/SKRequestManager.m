//
//  SKRequestManager.m
//  StackKit
//
//  Created by Dave DeLong on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SKRequestManager.h"
#import <CoreData/CoreData.h>
#import <StackKit/SKFunctions.h>
#import <StackKit/SKStackExchangeStore.h>
#import <StackKit/SKSite.h>
#import <StackKit/SKFetchRequest_Internal.h>
#import <StackKit/SKObject_Internal.h>
#import <StackKit/SKCache.h>

@interface SKRequestManager ()

-(NSURL *)dataModelURL;

@property (nonatomic, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation SKRequestManager {
    SKSite *_site;
    SKCache *_uniquedSKObjects;
    
    // assign references
    NSPersistentStore *stackExchangeStore;
    NSPersistentStore *sqliteStore;
}

@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (id)requestManagerWithSite:(SKSite *)site {
    SKRequestManager *manager = [[SKRequestManager alloc] _initWithSite:site];
    return [manager autorelease];
}

- (id)_initWithSite:(SKSite *)site {
    self = [super init];
    if (self) {
        _site = site;
        _uniquedSKObjects = [[SKCache cacheWithWeakToWeakObjects] retain];
    }
    return self;
}

- (void)dealloc {
    [_uniquedSKObjects release];
    [_managedObjectModel release];
    [_managedObjectContext release];
    [_persistentStoreCoordinator release];
    [super dealloc];
}

- (BOOL)shouldCacheDataLocally {
    return (sqliteStore != nil);
}

- (void)setShouldCacheDataLocally:(BOOL)shouldCacheDataLocally {
    BOOL isCaching = [self shouldCacheDataLocally];
    
    if (shouldCacheDataLocally != isCaching) {
        
        NSError *error = nil;
        if (isCaching) {
            [[self persistentStoreCoordinator] removePersistentStore:sqliteStore error:&error];
            sqliteStore = nil;
        } else {
            NSString *storeName = [NSString stringWithFormat:@"%@.skcache", [_site name]];
            NSString *cachePath = [SKApplicationSupportDirectory() stringByAppendingPathComponent:storeName];
            NSURL *cachingURL = [NSURL fileURLWithPath:cachePath];
            sqliteStore = [[self persistentStoreCoordinator] addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:cachingURL options:nil error:&error];
        }
        
        if (error != nil) {
            NSLog(@"error altering local caching settings: %@", error);
            sqliteStore = nil;
        }
    }
}

- (SKObject *)_objectOfType:(Class)skclass forInfoObject:(id)object {
    SKObject *wrapper = nil;
    
    if ([object isKindOfClass:[NSManagedObject class]]) {
        [_uniquedSKObjects cachedObjectForKey:object];
    }
    if (wrapper == nil) {
        wrapper = [NSAllocateObject(skclass, 0, nil) _initWithInfo:object site:_site];
        [_uniquedSKObjects cacheObject:wrapper forKey:object];
        [wrapper autorelease];
    }
    return wrapper;
}

- (void)executeRequest:(SKFetchRequest *)request asynchronously:(BOOL)async completionHandler:(SKRequestHandler)handler {
    NSFetchRequest *fetchRequest = [request _generatedFetchRequest];
    if ([request wantsLocalResults] && ([self shouldCacheDataLocally] == NO || [fetchRequest requestType] == NSDictionaryResultType)) {
        [NSException raise:NSInternalInconsistencyException format:@"can't fetch local results if there is no local cache"];
        return;
    }
    
    handler = [handler copy];
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    dispatch_block_t executionBlock = ^{
        @autoreleasepool {
            
            if ([request wantsLocalResults]) {
                [fetchRequest setAffectedStores:[NSArray arrayWithObject:sqliteStore]];
            } else {
                [fetchRequest setAffectedStores:[NSArray arrayWithObject:stackExchangeStore]];
            }
            
            NSError *error = nil;
            NSArray *objects = [context executeFetchRequest:fetchRequest error:&error];
            if (objects == nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    handler(nil, error);
                });
            } else {
                NSArray *results = nil;
                error = nil;
                if ([fetchRequest resultType] == NSDictionaryResultType || [fetchRequest resultType] == NSManagedObjectResultType) {
                    NSMutableArray *finalObjects = [NSMutableArray array];
                    for (id object in objects) {
                        SKObject *objectWrapper = [self _objectOfType:[request _targetClass] forInfoObject:object];
                        [finalObjects addObject:objectWrapper];
                    }
                    results = finalObjects;
                } else {
                    error = [NSError errorWithDomain:SKErrorDomain code:SKErrorCodeInvalidRequest userInfo:nil];
                }
                
                if (results != nil && [self shouldCacheDataLocally]) {
                    NSError *saveError = nil;
                    if (![context save:&saveError]) {
                        NSLog(@"error saving: %@", saveError);
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    handler(results, error);
                });
            }
        }
    };
    
    if (async) {
        [[self managedObjectContext] performBlock:executionBlock];
    } else {
        [[self managedObjectContext] performBlockAndWait:executionBlock];
    }
    
    [handler release];
}

#pragma mark - Core Data stack

- (NSURL *)dataModelURL {
    NSString *path = [SKBundle() pathForResource:@"StackKit.momd" ofType:nil inDirectory:nil];
    return [NSURL fileURLWithPath:path];
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
        
        //Since the SE API is readonly, the store should be as well.
        NSDictionary *storeOptions = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES]
                                                                 forKey:NSReadOnlyPersistentStoreOption];
        
        NSError *error = nil;
        SKStackExchangeStore *store = (SKStackExchangeStore*)[_persistentStoreCoordinator addPersistentStoreWithType:SKStoreType()
                                                                                                       configuration:nil
                                                                                                                 URL:[_site siteURL]
                                                                                                             options:storeOptions
                                                                                                               error:&error];
        if(error != nil) {
            NSLog(@"Cannot add the in-memory store type to the persistent store coordinator (%@), error: %@", _persistentStoreCoordinator, [error localizedDescription]);
            
            [_persistentStoreCoordinator release];
            _persistentStoreCoordinator = nil;
        } else {
            //Set ourselves as the site associated with the SKStackExchangeStore.
            [store setSite:_site];
            stackExchangeStore = store;
        }
    }
    
    return _persistentStoreCoordinator;
}


@end
