//
//  SKSite.m
//  StackKit
//
//  Created by Dave DeLong on 12/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <StackKit/SKSite_Internal.h>
#import <CoreData/CoreData.h>
#import <StackKit/SKConstants.h>
#import <StackKit/SKFunctions.h>
#import <StackKit/SKObject_Internal.h>
#import <StackKit/SKStackExchangeStore.h>
#import <StackKit/SKFetchRequest_Internal.h>
#import <StackKit/SKCache.h>
#import <StackKit/SKSiteCache.h>

@interface SKSite()

-(NSURL *)dataModelURL;

@property (nonatomic, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation SKSite {
    SKCache *_uniquedSKObjects;
}

@dynamic name;
@dynamic audience;
@dynamic launchDate;

@dynamic logoURL;
@dynamic siteURL;
@dynamic iconURL;
@dynamic faviconURL;

@dynamic APISiteParameter;

@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (void)requestSitesWithCompletionHandler:(SKRequestHandler)handler {
    [[SKSiteCache sharedSiteCache] requestAllSitesWithCompletionHandler:handler];
}

+ (void)requestSiteWithNameLike:(NSString *)name completionHandler:(SKSiteHandler)handler {
    handler = [handler copy];
    
    NSArray *words = [name componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    SKRequestHandler block = ^(NSArray *sites, NSError *error) {
        // this will be called on the main thread
        if (sites) {
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
            
            handler(match, nil);
        } else {
            handler(nil, error);
        }
    };
    
    [self requestSitesWithCompletionHandler:block];
    
    [handler release];
}

+ (void)requestSitesWithNames:(NSArray *)names completionHandler:(SKRequestHandler)handler {
    handler = [handler copy];
    [self requestSitesWithCompletionHandler:^(NSArray *sites, NSError *error) {
        NSArray *filtered = nil;
        if (sites) {
            NSArray *siteNames = [sites valueForKey:@"name"];
            NSDictionary *map = [NSDictionary dictionaryWithObjects:sites forKeys:siteNames];
            filtered = [map objectsForKeys:names notFoundMarker:[NSNull null]];
        }
        handler(filtered,error);
    }];
    [handler release];
}

#pragma mark -
#pragma mark SKSite Instance Stuff

+ (NSArray *)APIKeysBackingProperties {
    static dispatch_once_t onceToken;
    static NSArray *array = nil;
    dispatch_once(&onceToken, ^{
        array = [[NSArray alloc] initWithObjects:
                 SKAPIKeys.site.name,
                 SKAPIKeys.site.audience,
                 SKAPIKeys.site.launchDate,
                 SKAPIKeys.site.logoURL,
                 SKAPIKeys.site.siteURL,
                 SKAPIKeys.site.iconURL,
                 SKAPIKeys.site.faviconURL,
                 SKAPIKeys.site.siteState,
                 SKAPIKeys.site.apiSiteParameter,
                 nil];
    });
    return array;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    NSDictionary *info = [aDecoder decodeObjectForKey:@"info"];
    return [self _initWithInfo:info site:nil];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:[self _info] forKey:@"info"];
}

- (id)_initWithInfo:(id)info site:(SKSite *)site {
    self = [super _initWithInfo:info site:nil];
    if (self) {
        _uniquedSKObjects = [[SKCache cacheWithWeakToWeakObjects] retain];
    }
    return self;
}

- (void)dealloc {
    [_managedObjectModel release];
    [_managedObjectContext release];
    [_persistentStoreCoordinator release];
    [_uniquedSKObjects release];
    [super dealloc];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ {name = %@, url = %@}", 
            [super description],
            [self name],
            [self siteURL]];
}

// this has a non-object return type, so we'll override the getter manually
- (SKSiteState)siteState {
    NSString *value = [self _valueForInfoKey:SKAPIKeys.site.siteState];
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

- (SKSite *)site {
    return self;
}

#pragma mark Core Data stack


- (void)executeFetchRequest:(SKFetchRequest *)request completionHandler:(SKRequestHandler)handler {
    
    handler = [handler copy];
    
    // YES this introduces a retain cycle on self
    // deal with it.
    [[self managedObjectContext] performBlock:^{
        NSManagedObjectContext *context = [self managedObjectContext];
        NSFetchRequest *fetchRequest = [request _generatedFetchRequest];
        
        NSError *error = nil;
        NSArray *objects = [context executeFetchRequest:fetchRequest error:&error];
        if (!objects) {
            handler(nil, error);
        } else {
            if (NO) {
                // TODO: this is the case where they only requested the count
            } else {
                NSMutableArray *finalObjects = [NSMutableArray array];
                for (NSManagedObject *object in objects) {
                    SKObject *objectWrapper = [_uniquedSKObjects cachedObjectForKey:object];
                    if (!objectWrapper) {
                        objectWrapper = [[NSAllocateObject([request _targetClass], 0, nil) _initWithInfo:object site:self] autorelease];
                        
                        [_uniquedSKObjects cacheObject:objectWrapper forKey:object];
                    }
                    [finalObjects addObject:objectWrapper];
                }
                objects = finalObjects;
            }
            handler(objects, nil);
        }
    }];
    
    [handler release];
}

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
                                                                                                                 URL:[self siteURL]
                                                                                                             options:storeOptions
                                                                                                               error:&error];
        if(error != nil) {
            NSLog(@"Cannot add the in-memory store type to the persistent store coordinator (%@), error: %@", _persistentStoreCoordinator, [error localizedDescription]);
            
            [_persistentStoreCoordinator release];
            _persistentStoreCoordinator = nil;
        } else {
            //Set ourselves as the site associated with the SKStackExchangeStore.
            [store setSite:self];
        }
    }
    
    return _persistentStoreCoordinator;
}

@end
