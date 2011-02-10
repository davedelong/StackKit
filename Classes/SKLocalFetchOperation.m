//
//  SKLocalFetchOperation.m
//  StackKit
//
//  Created by Dave DeLong on 2/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SKLocalFetchOperation.h"
#import "SKFetchRequest+Private.h"
#import "SKSite+Private.h"

@implementation SKLocalFetchOperation

- (void) main {
	
    NSManagedObjectContext *context = [site managedObjectContext];
    NSFetchRequest *coreDataRequest = [(SKLocalFetchRequest *)request coreDataFetchRequestForManagedObjectContext:context];
    [request release];
    
    NSError *e = nil;
    [context lock];
    NSArray *objects = [context executeFetchRequest:coreDataRequest error:&e];
    [context unlock];
    
    if (e != nil || [objects count] == 0) {
        objects = nil;
    }
    
    SKFetchRequestHandler h = [self handler];
    dispatch_async(dispatch_get_main_queue(), ^{
        h(objects); 
    });
}

@end
