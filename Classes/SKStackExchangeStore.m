//
//  SKStackExchangeStore.m
//  StackKit
//
//  Created by Jacob Relkin on 12/31/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <StackKit/SKStackExchangeStore.h>
#import <StackKit/SKFetchRequest_Internal.h>
#import <StackKit/SKFunctions.h>
#import <StackKit/SKTypes.h>
#import <StackKit/SKConstants.h>

static NSString * _SKStackExchangeStoreType = @"SKStackExchangeStore";

NSString * SKStoreType(void) {
    //Make sure that the class is loaded prior to returning the store type string.
    if(!NSClassFromString(_SKStackExchangeStoreType)) {
        [NSException raise:NSInternalInconsistencyException format:@"Could not load the SKStackExchangeStore class."];
    }
    
    return _SKStackExchangeStoreType;
}

@interface SKStackExchangeStore ()

- (NSArray *)_buildObjectsFromResponse:(NSDictionary *)response originalRequest:(NSFetchRequest *)request context:(NSManagedObjectContext *)context;

@end

@implementation SKStackExchangeStore {
    NSMutableDictionary *_caches;
}

@synthesize site = _site;

+(void)load {
    //We can't use +initialize because it only gets invoked when the first message is sent to a class.
    //At the point that -[NSPersistentStoreCoordinator addPersistentStoreWithType:...]
    //is invoked, there is zero expectation that the above condition (sending a message to [self class]) has been met.
    //Therefore, +load is the way to go.
    
    //Obvious side effect here is that when this class is loaded, the NSPersistentStoreCoordinator class will be loaded.
    
    //Add this store class to the NSPersistentStoreCoordinator's store registry.
    //We don't need a dispatch_once here because +load is guaranteed to
    //be invoked only once per class,  not to mention that registerStoreClass:forStoreType:
    //is essentially a no-op if the class is already registered.
    
    [NSPersistentStoreCoordinator registerStoreClass:[self class]
                                        forStoreType:SKStoreType()];
}

- (void)dealloc {
    [_caches release];
    [super dealloc];
}

- (NSCache *)_cacheForClass:(Class)class {
    if (_caches == nil) {
        _caches = [[NSMutableDictionary alloc] init];
    }
    
    NSCache *cache = [_caches objectForKey:class];
    if (cache == nil) {
        cache = [[[NSCache alloc] init] autorelease];
        [_caches setObject:cache forKey:class];
    }
    
    return cache;
}

- (BOOL)loadMetadata:(NSError **)error {
    return YES;
}

- (id)executeRequest:(NSPersistentStoreRequest *)request withContext:(NSManagedObjectContext *)context error:(NSError **)error {
    id returnValue = nil;
    
    if ([request requestType] != NSFetchRequestType) {
        if (error) {
            *error = [NSError errorWithDomain:SKErrorDomain code:SKErrorCodeInvalidMethod userInfo:nil];
        }
        return nil;
    }
    
    if (![request isKindOfClass:[NSFetchRequest class]]) {
        if (error) {
            *error = [NSError errorWithDomain:SKErrorDomain code:SKErrorCodeInternalError userInfo:nil];
        }
        return nil;
    }
    
    NSFetchRequest *fetchRequest = (NSFetchRequest *)request;
    //Do something with fetchRequest...
    SKFetchRequest *seRequest = [fetchRequest stackKitFetchRequest];
    NSURL *apiCall = [seRequest _apiURLWithSite:[self site]];
    
    NSDictionary *response = SKExecuteAPICall(apiCall, error);
    
    if (response && !SKExtractError(response, error)) {
        if ([fetchRequest resultType] == NSCountResultType) {
            
        } else if ([fetchRequest resultType] == NSManagedObjectResultType) {
            returnValue = [self _buildObjectsFromResponse:response originalRequest:fetchRequest context:context];
        } else {
            *error = [NSError errorWithDomain:SKErrorDomain code:SKErrorCodeInvalidMethod userInfo:nil];
            return nil;
        }
    }
    
    if (!returnValue && error && !*error) {
        *error = [NSError errorWithDomain:SKErrorDomain code:SKErrorCodeInternalError userInfo:nil];
    }
    
    return returnValue;
}

- (NSIncrementalStoreNode *)newValuesForObjectWithID:(NSManagedObjectID *)objectID withContext:(NSManagedObjectContext *)context error:(NSError **)error {
    
    NSDictionary *d = [self referenceObjectForObjectID:objectID];
    
    NSIncrementalStoreNode *node = [[NSIncrementalStoreNode alloc] initWithObjectID:objectID withValues:d version:1];
    return node;
}

- (NSArray *)_buildObjectsFromResponse:(NSDictionary *)response originalRequest:(NSFetchRequest *)request context:(NSManagedObjectContext *)context {
    NSArray *items = [response objectForKey:SKAPIKeys.items];
    
    NSMutableArray *objects = [NSMutableArray array];
    for (NSDictionary *d in items) {
        NSManagedObjectID *objectID = [self newObjectIDForEntity:[request entity] referenceObject:d];
        NSManagedObject *object = [context objectWithID:objectID];
        
        [objects addObject:object];
    }
    return objects;
}

- (id)newValueForRelationship:(NSRelationshipDescription *)relationship forObjectWithID:(NSManagedObjectID *)objectID withContext:(NSManagedObjectContext *)context error:(NSError **)error {
    return nil;
}

- (NSArray *)obtainPermanentIDsForObjects:(NSArray *)array error:(NSError **)error {
    return nil;
}

@end
