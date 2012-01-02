//
//  SKCache.m
//  StackKit
//
//  Created by Dave DeLong on 1/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SKCache.h"
#import <objc/runtime.h>

@interface SKCacheHelper : NSObject
@property (nonatomic, copy) dispatch_block_t deallocBlock;
@end
@implementation SKCacheHelper
@synthesize deallocBlock;
- (void)dealloc {
    if (deallocBlock) {
        deallocBlock();
    }
    
    [deallocBlock release];
    [super dealloc];
}
@end

@implementation SKCache {
    BOOL retainsKeys;
    BOOL retainsValues;
    
    CFMutableDictionaryRef cache;
}

- (id)initAndRetainsKeys:(BOOL)keys retainsValues:(BOOL)values {
    self = [super init];
    if (self) {
        retainsKeys = keys;
        retainsValues = values;
        
        CFDictionaryKeyCallBacks keyCallbacks = kCFTypeDictionaryKeyCallBacks;
        CFDictionaryValueCallBacks valueCallbacks = kCFTypeDictionaryValueCallBacks;
        
        if (!retainsKeys) {
            keyCallbacks.retain = NULL;
            keyCallbacks.release = NULL;
        }
        
        if (!retainsValues) {
            valueCallbacks.retain = NULL;
            valueCallbacks.release = NULL;
        }
        
        cache = CFDictionaryCreateMutable(NULL, 42, &keyCallbacks, &valueCallbacks);
    }
    return self;
}

- (void)dealloc {
    CFRelease(cache);
    [super dealloc];
}

+ (id)cacheWithStrongToWeakObjects { return [[[SKCache alloc] initAndRetainsKeys:YES retainsValues:NO] autorelease]; }
+ (id)cacheWithWeakToWeakObjects { return [[[SKCache alloc] initAndRetainsKeys:NO retainsValues:NO] autorelease]; }
+ (id)cacheWithWeakToStrongObjects { return [[[SKCache alloc] initAndRetainsKeys:NO retainsValues:YES] autorelease]; }
+ (id)cacheWithStrongToStrongObjects { return [[[SKCache alloc] initAndRetainsKeys:YES retainsValues:YES] autorelease]; }

- (void)_objectDeallocated:(id)value wasKey:(BOOL)wasKey {
    if (wasKey) {
        // the key was removed
        CFDictionaryRemoveValue(cache, (const void *)value);
    } else {
        // the value was removed
        NSArray *keys = [(NSDictionary *)cache allKeysForObject:value]; // dirty dirty
        id key = [keys objectAtIndex:0];
        CFDictionaryRemoveValue(cache, (const void *)key);
    }
}

- (void)_observeDeallocationOfObject:(id)object isKey:(BOOL)isKey {
    static void *SKCacheKey;
    
    NSValue *v = [NSValue valueWithNonretainedObject:object];
    dispatch_block_t block = ^{
        [self _objectDeallocated:[v nonretainedObjectValue] wasKey:isKey];
    };
    
    SKCacheHelper *helper = [[SKCacheHelper alloc] init];
    [helper setDeallocBlock:block];
    
    objc_setAssociatedObject(object, &SKCacheKey, helper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [helper release];
}

- (void)cacheObject:(id)object forKey:(id)key {
    if (key == nil) { return; }
    
    if (object == nil) {
        CFDictionaryRemoveValue(cache, (const void *)key);
        return;
    }
    
    if (!retainsKeys) {
        // the keys aren't retained, so we need to know when the key is deallocated
        [self _observeDeallocationOfObject:key isKey:YES];
    }
    
    if (!retainsValues) {
        // the values aren't retained, so we need to know when the value is deallocated
        [self _observeDeallocationOfObject:object isKey:NO];
    }
    
    CFDictionarySetValue(cache, (const void *)key, (const void *)object);
}

- (id)cachedObjectForKey:(id)key {
    return (id)CFDictionaryGetValue(cache, (const void *)key);
}

@end
