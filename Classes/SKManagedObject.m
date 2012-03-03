//
//  SKManagedObject.m
//  StackKit
//
//  Created by Dave DeLong on 3/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SKManagedObject.h"

@implementation SKManagedObject

@synthesize uniqueIdentifier=_uniqueIdentifier;

- (NSString *)uniqueIdentifier {
    if (_uniqueIdentifier == nil) {
        NSString *entityName = [[self entity] name];
        
        NSString *uniqueField = nil;
        if (uniqueField != nil) {
            __block id uniqueValue = nil;
            [[self managedObjectContext] performBlockAndWait:^{
                uniqueValue = [self valueForKey:uniqueField];
            }];
            if (uniqueValue != nil) {
                _uniqueIdentifier = [[NSString alloc] initWithFormat:@"%@.%@", entityName, uniqueValue];
            }
        }
    }
    return _uniqueIdentifier;
}

- (void)dealloc {
    [_uniqueIdentifier release];
    [super dealloc];
}

@end
