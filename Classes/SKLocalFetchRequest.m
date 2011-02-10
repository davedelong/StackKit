//
//  SKLocalFetchRequest.m
//  StackKit
//
//  Created by Dave DeLong on 2/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SKLocalFetchRequest.h"
#import "SKObject+Private.h"
#import "SKLocalFetchOperation.h"

@implementation SKLocalFetchRequest

+ (Class) operationClass {
    return [SKLocalFetchOperation class];
}

- (NSFetchRequest *) coreDataFetchRequestForManagedObjectContext:(NSManagedObjectContext *)moc {
    NSFetchRequest * r = [[NSFetchRequest alloc] init];
    [r setPredicate:[self predicate]];
    [r setSortDescriptors:[NSArray arrayWithObject:[self sortDescriptor]]];

    NSEntityDescription *e = [[self entity] entityInManagedObjectContext:moc];
    [r setEntity:e];
    
    [r setFetchLimit:[self fetchLimit]];
    [r setFetchOffset:[self fetchOffset]];
    
    return [r autorelease];
}

- (void) setFetchLimit:(NSUInteger)aFetchLimit {
    fetchLimit = aFetchLimit;
}

@end
