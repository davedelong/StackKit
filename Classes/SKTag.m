//
//  SKTag.m
//  StackKit
//
//  Created by Dave DeLong on 1/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <StackKit/SKTag.h>
#import <StackKit/SKObject_Internal.h>
#import <StackKit/SKConstants.h>

@implementation SKTag

@dynamic name;
@dynamic count;
@dynamic required;
@dynamic moderatorOnly;

+ (NSString *)_uniquelyIdentifyingAPIKey {
    return SKAPIKeys.tag.name;
}

+ (NSArray *)APIKeysBackingProperties {
    static dispatch_once_t onceToken;
    static NSArray *keys = nil;
    dispatch_once(&onceToken, ^{
        keys = [[NSArray alloc] initWithObjects:
                SKAPIKeys.tag.name,
                SKAPIKeys.tag.count,
                SKAPIKeys.tag.isRequired,
                SKAPIKeys.tag.isModeratorOnly,
                nil];
    });
    return keys;
}

@end
