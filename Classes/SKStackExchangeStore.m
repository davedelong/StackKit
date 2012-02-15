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
#import <StackKit/SKObject_Internal.h>
#import <StackKit/SKCache.h>

NSString* SKStoreType(void) {
    //Make sure that the class is loaded prior to returning the store type string.
    Class c = [SKStackExchangeStore class];
    if(c == nil) {
        [NSException raise:NSInternalInconsistencyException format:@"Could not load the SKStackExchangeStore class."];
    }
    
    return NSStringFromClass(c);
}

@interface SKStackExchangeStore ()

- (NSArray *)_buildObjectsFromResponse:(NSDictionary *)response originalRequest:(NSFetchRequest *)request context:(NSManagedObjectContext *)context;

@end

@implementation SKStackExchangeStore {
    SKCache *_referenceObjectToNodeCache;
    SKCache *_referenceObjectToValuesCache;
}

@synthesize site = _site;

+(void)initialize {
    //It turns out using +initialize is just fine.
    
    [NSPersistentStoreCoordinator registerStoreClass:[self class]
                                        forStoreType:SKStoreType()];
}

- (id)initWithPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)root configurationName:(NSString *)name URL:(NSURL *)url options:(NSDictionary *)options {
    self = [super initWithPersistentStoreCoordinator:root configurationName:name URL:url options:options];
    if (self) {
        _referenceObjectToValuesCache = [[SKCache cacheWithStrongToStrongObjects] retain];
        _referenceObjectToNodeCache = [[SKCache cacheWithStrongToWeakObjects] retain];
    }
    return self;
}

- (void)dealloc {
    [_referenceObjectToValuesCache release];
    [_referenceObjectToNodeCache release];
    [super dealloc];
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
            if (error) {
                *error = [NSError errorWithDomain:SKErrorDomain code:SKErrorCodeInvalidMethod userInfo:nil];
            }
            return nil;
        }
    }
    
    if (!returnValue && error && !*error) {
        *error = [NSError errorWithDomain:SKErrorDomain code:SKErrorCodeInternalError userInfo:nil];
    }
    
    return returnValue;
}

- (NSIncrementalStoreNode *)newValuesForObjectWithID:(NSManagedObjectID *)objectID withContext:(NSManagedObjectContext *)context error:(NSError **)error {
    NSString *uniqueID = [self referenceObjectForObjectID:objectID];
    NSDictionary *values = [_referenceObjectToValuesCache cachedObjectForKey:uniqueID];
    
    NSIncrementalStoreNode *node = [[NSIncrementalStoreNode alloc] initWithObjectID:objectID withValues:values version:1];
    // cache the node keyed off the uniqueID
    [_referenceObjectToNodeCache cacheObject:node forKey:uniqueID];
    
    return node;
}

- (NSArray *)_buildObjectsFromResponse:(NSDictionary *)response originalRequest:(NSFetchRequest *)request context:(NSManagedObjectContext *)context {
    NSArray *items = [response objectForKey:SKAPIKeys.items];
    
    Class targetClass = [[request stackKitFetchRequest] _targetClass];
    NSString *uniqueIdentifierKey = [targetClass _uniquelyIdentifyingAPIKey];
    
    NSMutableArray *objects = [NSMutableArray array];
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init]; {
        for (NSDictionary *d in items) {
            d = [targetClass _mutateResponseDictionary:d];
            id uniqueValue = [d objectForKey:uniqueIdentifierKey];
            NSString *uniqueID = [NSString stringWithFormat:@"%@:%@", uniqueIdentifierKey, uniqueValue];
            
            NSManagedObjectID *objectID = nil;
            NSIncrementalStoreNode *node = [_referenceObjectToNodeCache cachedObjectForKey:uniqueID];
            
            if (node) {
                NSMutableDictionary *newValues = [[_referenceObjectToValuesCache cachedObjectForKey:uniqueID] mutableCopy];
                [newValues addEntriesFromDictionary:d];
                d = [newValues autorelease];
                
                [node updateWithValues:d version:[node version]+1];
                objectID = [node objectID];
            }
            
            if (objectID == nil) {
                objectID = [[self newObjectIDForEntity:[request entity] referenceObject:uniqueID] autorelease];
            }
            
            [_referenceObjectToValuesCache cacheObject:d forKey:uniqueID];
            
            NSManagedObject *object = [context objectWithID:objectID];
            
            [objects addObject:object];
        }
    } [pool drain];
    
    return objects;
}

- (id)newValueForRelationship:(NSRelationshipDescription *)relationship forObjectWithID:(NSManagedObjectID *)objectID withContext:(NSManagedObjectContext *)context error:(NSError **)error {
    return nil;
}

- (NSArray *)obtainPermanentIDsForObjects:(NSArray *)array error:(NSError **)error {
    return nil;
}

@end
