//
//  SKFetchRequest.m
//  StackKit
//
//  Created by Dave DeLong on 12/31/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <StackKit/SKFetchRequest_Internal.h>
#import <StackKit/SKConstants.h>
#import <StackKit/SKFunctions.h>
#import <StackKit/SKSite_Internal.h>

#import <StackKit/SKObject_Internal.h>
#import <StackKit/SKUser.h>
#import <objc/runtime.h>

static void *NSFetchRequestStackKitFetchRequestKey;

@implementation NSFetchRequest (StackKit)

- (SKFetchRequest *)stackKitFetchRequest {
    return objc_getAssociatedObject(self, &NSFetchRequestStackKitFetchRequestKey);
}

- (void)setStackKitFetchRequest:(SKFetchRequest *)stackKitFetchRequest {
    objc_setAssociatedObject(self, &NSFetchRequestStackKitFetchRequestKey, stackKitFetchRequest, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation SKFetchRequest

+ (SKUserFetchRequest *)requestForFetchingUsers {
    if (self != [SKFetchRequest class]) {
        [NSException raise:NSInternalInconsistencyException 
                    format:@"+%@ may only be invoked on SKFetchRequest", NSStringFromSelector(_cmd)];
    }
    
    return [[[SKUserFetchRequest alloc] init] autorelease];
}

- (NSFetchRequest *)_generatedFetchRequest {
    [NSException raise:NSInternalInconsistencyException 
                format:@"-%@ must be overridden by subclasses", NSStringFromSelector(_cmd)];
    return nil;
}

- (NSURL *)_apiURLWithSite:(SKSite *)site {
    [NSException raise:NSInternalInconsistencyException 
                format:@"-%@ must be overridden by subclasses", NSStringFromSelector(_cmd)];
    return nil;
}

@end

@implementation SKUserFetchRequest

@synthesize minDate=_minDate;
@synthesize maxDate=_maxDate;
@synthesize sortKey=_sortKey;
@synthesize nameContains=_nameContains;
@synthesize userIDs=_userIDs;
@synthesize ascending=_ascending;

- (void)dealloc {
    [_minDate release];
    [_maxDate release];
    [_sortKey release];
    [_nameContains release];
    [_userIDs release];
    [super dealloc];
}

- (id)createdSince:(NSDate *)date {
    [self setMinDate:date];
    return self;
}

- (id)createdBefore:(NSDate *)date {
    [self setMaxDate:date];
    return self;
}

- (id)sortedByCreationDate {
    [self setSortKey:SKAPIKeys.user.creationDate];
    return self;
}

- (id)sortedByName {
    [self setSortKey:SKAPIKeys.user.displayName];
    return self;
}

- (id)sortedByReputation {
    [self setSortKey:SKAPIKeys.user.reputation];
    return self;
}

- (id)sortedByLastModifiedDate {
    [self setSortKey:SKAPIKeys.user.lastModifiedDate];
    return self;
}

- (id)inAscendingOrder {
    [self setAscending:YES];
    return self;
}

- (id)inDescendingOrder {
    [self setAscending:NO];
    return self;
}

- (id)whoseDisplayNameContains:(NSString *)name {
    [self setNameContains:name];
    return self;
}

- (id)withIDs:(NSUInteger)userID,... {
    NSMutableIndexSet *ids = [NSMutableIndexSet indexSet];
    
    if (userID > 0) {
        [ids addIndex:userID];
        va_list list;
        va_start(list, userID);
        
        NSUInteger nextID = 0;
        while ((nextID = va_arg(list, NSUInteger)) != 0) {
            [ids addIndex:nextID];
        }
        
        va_end(list);
    }
    
    [self setUserIDs:ids];
    return self;
}

- (NSFetchRequest *)_generatedFetchRequest {
    // why bother to generate a proper NSFetchRequest?
    // for consistency, i suppose
    
    NSFetchRequest *r = [[NSFetchRequest alloc] initWithEntityName:[SKUser _entityName]];
    
    if ([_sortKey length] > 0) {
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:SKInferPropertyNameFromAPIKey(_sortKey) ascending:_ascending];
        [r setSortDescriptors:[NSArray arrayWithObject:sort]];
    }
    
    NSMutableArray *subpredicates = [NSMutableArray array];
    if ([_nameContains length] > 0) {
        NSString *name = SKInferPropertyNameFromAPIKey(SKAPIKeys.user.displayName);
        NSPredicate *p = [NSPredicate predicateWithFormat:@"%K CONTAINS[cd] %@", name, _nameContains];
        [subpredicates addObject:p];
    }
    
    if ([_userIDs count] > 0) {
        NSMutableArray *ids = [NSMutableArray array];
        [_userIDs enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
            NSString *userID = SKInferPropertyNameFromAPIKey(SKAPIKeys.user.userID);
            [ids addObject:[NSPredicate predicateWithFormat:@"%K = %lu", userID, idx]];
        }];
        [subpredicates addObject:[NSCompoundPredicate orPredicateWithSubpredicates:ids]];
    }
    
    if (_minDate != nil) {
        NSString *date = SKInferPropertyNameFromAPIKey(SKAPIKeys.user.creationDate);
        [subpredicates addObject:[NSPredicate predicateWithFormat:@"%K >= %@", date, _minDate]];
    }
    
    if (_maxDate != nil) {
        NSString *date = SKInferPropertyNameFromAPIKey(SKAPIKeys.user.creationDate);
        [subpredicates addObject:[NSPredicate predicateWithFormat:@"%K <= %@", date, _minDate]];
    }
    
    if ([subpredicates count] > 0) {
        NSPredicate *p = [NSCompoundPredicate andPredicateWithSubpredicates:subpredicates];
        [r setPredicate:p];
    }
    
    [r setStackKitFetchRequest:self];
    return [r autorelease];
}

- (NSURL *)_apiURLWithSite:(SKSite *)site {
    NSString *path = @"users";
    
    NSMutableDictionary *query = [NSMutableDictionary dictionary];
    [query setObject:[site APISiteParameter] forKey:SKQueryKeys.site];
    
    if ([_userIDs count] > 0) {
        path = [NSString stringWithFormat:@"users/%@", SKQueryString(_userIDs)];
    } else if ([_nameContains length] > 0) {
        [query setObject:SKQueryString(_nameContains) forKey:SKQueryKeys.user.nameContains];
    }
    
    if ([_sortKey length] > 0) {
        [query setObject:_sortKey forKey:SKQueryKeys.sort];
    }
    
    [query setObject:(_ascending ? SKQueryKeys.sortOrder.ascending : SKQueryKeys.sortOrder.descending) forKey:SKQueryKeys.order];
    
    if (_minDate) {
        [query setObject:SKQueryString(_minDate) forKey:SKQueryKeys.fromDate];
    }
    
    if (_maxDate) {
        [query setObject:SKQueryString(_maxDate) forKey:SKQueryKeys.toDate];
    }
    
    return SKConstructAPIURL(path, query);
}

@end
