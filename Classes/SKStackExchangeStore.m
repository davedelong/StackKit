//
//  SKStackExchangeStore.m
//  StackKit
//
//  Created by Jacob Relkin on 12/31/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SKStackExchangeStore.h"

@implementation SKStackExchangeStore

-(id)initWithPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)root configurationName:(NSString *)name URL:(NSURL *)url options:(NSDictionary *)options {
    
    self = [super initWithPersistentStoreCoordinator:root configurationName:name URL:url options:options];
    if(self) {
        //...
    }
    
    return self;
}

-(void)dealloc {
    [super dealloc];
    
    //...
}

-(BOOL)loadMetadata:(NSError **)error {
    return YES;
}

-(id)executeRequest:(NSPersistentStoreRequest *)request withContext:(NSManagedObjectContext *)context error:(NSError **)error {
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
