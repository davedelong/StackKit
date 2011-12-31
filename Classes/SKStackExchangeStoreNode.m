//
//  SKStackExchangeStoreNode.m
//  StackKit
//
//  Created by Jacob Relkin on 12/31/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <StackKit/SKStackExchangeStoreNode.h>

@interface SKStackExchangeStoreNode ()

@end

@implementation SKStackExchangeStoreNode

-(id)initWithObjectID:(NSManagedObjectID *)objectID withValues:(NSDictionary *)values version:(uint64_t)version {
    self = [super initWithObjectID:objectID
                        withValues:values
                           version:version];
    if(self) {
        //...
    }
    return self;
}

-(void)dealloc {
    [super dealloc];
    //...
}

-(void)updateWithValues:(NSDictionary *)values version:(uint64_t)version {
    //...
}

-(id)valueForPropertyDescription:(NSPropertyDescription *)prop {
    return nil;
}

-(NSManagedObjectID *)objectID {
    return nil;
}

@end
