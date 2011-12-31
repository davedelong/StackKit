//
//  SKStackExchangeStore.m
//  StackKit
//
//  Created by Jacob Relkin on 12/31/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <StackKit/SKStackExchangeStore.h>

static NSString * _SKStackExchangeStoreType = @"SKStackExchangeStore";

NSString * SKStoreType(void) {
    //Make sure that the class is loaded prior to returning the store type string.
    if(!NSClassFromString(_SKStackExchangeStoreType)) {
        [NSException raise:NSInternalInconsistencyException format:@"Could not load the SKStackExchangeStore class."];
    }
    
    return _SKStackExchangeStoreType;
}

@interface SKStackExchangeStore ()

@end

@implementation SKStackExchangeStore

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

//TODO: Fill in these methods:

-(id)initWithPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)root configurationName:(NSString *)name URL:(NSURL *)url options:(NSDictionary *)options {
    
    self = [super initWithPersistentStoreCoordinator:root configurationName:name URL:url options:options];
    if(self) {
        //...
    }
    
    return self;
}

-(void)dealloc {
    
    //...
    [super dealloc];
}

-(BOOL)loadMetadata:(NSError **)error {
    return YES;
}

-(id)executeRequest:(NSPersistentStoreRequest *)request withContext:(NSManagedObjectContext *)context error:(NSError **)error {
    if([request requestType] == NSSaveRequestType) {
        
    } else {
        if([request isKindOfClass:[NSFetchRequest class]]) {
            //Do something with fetchRequest...
            NSLog(@"got a request: %@", request);
        }
    }
    return nil;
}

-(NSIncrementalStoreNode *)newValuesForObjectWithID:(NSManagedObjectID *)objectID withContext:(NSManagedObjectContext *)context error:(NSError **)error {
    return nil;
}

-(id)newValueForRelationship:(NSRelationshipDescription *)relationship forObjectWithID:(NSManagedObjectID *)objectID withContext:(NSManagedObjectContext *)context error:(NSError **)error {
    return nil;
}

-(NSArray *)obtainPermanentIDsForObjects:(NSArray *)array error:(NSError **)error {
    return nil;
}


@end
