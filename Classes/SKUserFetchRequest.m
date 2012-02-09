//
//  SKUserFetchRequest.m
//  StackKit
//
//  Created by Dave DeLong on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SKUserFetchRequest.h"
#import <StackKit/SKConstants.h>
#import <StackKit/SKFunctions.h>
#import <StackKit/SKUser.h>

@implementation SKUserFetchRequest

+ (Class)_targetClass { return [SKUser class]; }

@synthesize minDate=_minDate;
@synthesize maxDate=_maxDate;
@synthesize nameContains=_nameContains;
@synthesize userIDs=_userIDs;

- (id)init {
    self = [super init];
    if (self) {
        _userIDs = [[NSMutableIndexSet alloc] init];
    }
    return self;
}

- (void)dealloc {
    [_minDate release];
    [_maxDate release];
    [_nameContains release];
    [_userIDs release];
    [super dealloc];
}

- (id)createdAfter:(NSDate *)date {
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

- (id)whoseDisplayNameContains:(NSString *)name {
    [self setNameContains:name];
    return self;
}

- (id)withIDs:(NSUInteger)userID,... {
    if (userID > 0) {
        [_userIDs addIndex:userID];
        va_list list;
        va_start(list, userID);
        
        NSUInteger nextID = 0;
        while ((nextID = va_arg(list, NSUInteger)) != 0) {
            [_userIDs addIndex:nextID];
        }
        
        va_end(list);
    }
    return self;
}

- (NSFetchRequest *)_generatedFetchRequest {
    // why bother to generate a proper NSFetchRequest?
    // for consistency, i suppose
    
    NSFetchRequest *r = [super _generatedFetchRequest];
    
    if ([[self sortKey] length] > 0) {
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:SKInferPropertyNameFromAPIKey([self sortKey]) ascending:[self ascending]];
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
    return r;
}

- (NSString *)_path {
    NSString *p = @"users";
    if ([_userIDs count] > 0) {
        p = [NSString stringWithFormat:@"users/%@", SKQueryString(_userIDs)];        
    }
    return p;
}

- (NSMutableDictionary *)_queryDictionary {
    NSMutableDictionary *d = [super _queryDictionary];
    
    if (_minDate) {
        [d setObject:SKQueryString(_minDate) forKey:SKQueryKeys.fromDate];
    }
    
    if (_maxDate) {
        [d setObject:SKQueryString(_maxDate) forKey:SKQueryKeys.toDate];
    }
    
    if ([_userIDs count] == 0 && [_nameContains length] > 0) {
        [d setObject:SKQueryString(_nameContains) forKey:SKQueryKeys.user.nameContains];
    }
    
    return d;
}

@end
