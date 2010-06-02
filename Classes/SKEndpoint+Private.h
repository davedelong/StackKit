//
//  SKEndpoint+Private.h
//  StackKit
//
//  Created by Dave DeLong on 6/2/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKEndpoint.h"

@interface SKEndpoint ()

@property (retain) NSMutableDictionary * query;
@property (retain) NSString * path;
@property (retain) NSError * error;

- (BOOL) validateEntity:(Class)entity;
- (BOOL) validatePredicate:(NSPredicate *)predicate;
- (BOOL) validateSortDescriptor:(NSSortDescriptor *)sortDescriptor;

@end