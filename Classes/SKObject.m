//
//  SKObject.m
//  StackKit
//
//  Created by Dave DeLong on 12/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <StackKit/SKObject_Internal.h>
#import <StackKit/SKFunctions.h>
#import <StackKit/SKMacros.h>
#import <objc/runtime.h>
#import <CoreData/CoreData.h>

@implementation SKObject {
    // _info will be either an NSDictionary or NSManagedObject, depending on the subclass
    // either way, it'll respond to -valueForKey:
    id _info;
}

+ (id)allocWithZone:(NSZone *)zone {
    [NSException raise:NSInternalInconsistencyException format:@"You may not allocate instances of %@", NSStringFromClass(self)];
    return nil;
}

+ (NSString *)_uniquelyIdentifyingAPIKey {
    REQUIRE_OVERRIDE;
    return nil;
}

+ (NSDictionary *)_mutateResponseDictionary:(NSDictionary *)d {
    return d;
}

+ (NSString *)_entityName {
    return NSStringFromClass(self);
}

+ (NSArray *)APIKeysBackingProperties {
    REQUIRE_OVERRIDE;
    return nil;
}

+ (NSString *)inferredPropertyNameFromAPIKey:(NSString *)apiKey {
    return SKInferPropertyNameFromAPIKey(apiKey);
}

+ (NSDictionary *)APIKeysToPropertyMapping {
    NSDictionary *mapping = objc_getAssociatedObject(self, _cmd);
    if (mapping == nil) {
        NSArray *apiKeys = [self APIKeysBackingProperties];
        NSMutableDictionary *d = [[NSMutableDictionary alloc] init];
        for (NSString *apiKey in apiKeys) {
            NSString *propertyName = [self inferredPropertyNameFromAPIKey:apiKey];
            [d setObject:propertyName forKey:apiKey];
        }
        objc_setAssociatedObject(self, _cmd, d, OBJC_ASSOCIATION_COPY);
        mapping = [d autorelease];
    }
    return mapping;
}

+ (NSDictionary *)propertyToAPIKeysMapping {
    NSDictionary *mapping = objc_getAssociatedObject(self, _cmd);
    if (mapping == nil) {
        NSDictionary *otherMap = [self APIKeysToPropertyMapping];
        NSArray *keys = [otherMap allKeys];
        NSArray *values = [otherMap objectsForKeys:keys notFoundMarker:[NSNull null]];
        
        // the keys from the other map become the objects in this map
        mapping = [NSDictionary dictionaryWithObjects:keys forKeys:values];
        objc_setAssociatedObject(self, _cmd, mapping, OBJC_ASSOCIATION_COPY);
    }
    return mapping;
}

+ (NSString *)_infoKeyForSelector:(SEL)selector {
    return [[self propertyToAPIKeysMapping] objectForKey:NSStringFromSelector(selector)];
}

+ (id)_transformValue:(id)value forReturnType:(Class)returnType {
    if (returnType == [NSURL class]) {
        value = [NSURL URLWithString:value];
    } else if (returnType == [NSDate class]) {
        value = [NSDate dateWithTimeIntervalSince1970:[value doubleValue]];
    }
    
    return value;
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    // wooo handle the @dynamic properties!
    objc_property_t property = class_getProperty(self, sel_getName(sel));
    if (property == NULL) { return NO; }
    
    NSString *key = [self _infoKeyForSelector:sel];
    
    char *value = property_copyAttributeValue(property, "T");
    int length = strlen(value);
    Class returnType = [NSString class];
    SEL valueSelector = nil;
    if (length > 3) {
        // the type is of the form @"ClassName"
        // this will create a string skipping the leading @" and trailing "
        NSString *className = [[NSString alloc] initWithBytes:value+2 length:length-3 encoding:NSUTF8StringEncoding];
        returnType = NSClassFromString(className);
        [className release];
    } else {
        if (value[0] == '@') {
            // the return type is an object, but we don't know what class
            
        } else if (strcmp(value, @encode(NSUInteger)) == 0) {
            // it's an NSUInteger
            valueSelector = @selector(unsignedIntegerValue);
        } else if (strcmp(value, @encode(BOOL)) == 0) {
            // it's a BOOL
            valueSelector = @selector(boolValue);
        } else if (strcmp(value, @encode(int)) == 0) {
            // it's an int (or some typedef'd enum)
            valueSelector = @selector(intValue);
        }
    }
    
    
    
    id(^impBlock)(SKObject *) = ^(SKObject *_s){
        id value = [_s _valueForInfoKey:key];
        if (valueSelector == nil || ![value isKindOfClass:[NSNumber class]]) {
            value = [[_s class] _transformValue:value forReturnType:returnType];  
        } else {
            value = [value performSelector:valueSelector];
        }
        return value;
    };
    
    IMP newIMP = imp_implementationWithBlock((void *)impBlock);
    
    NSString *methodSignature = [NSString stringWithFormat:@"%c@:", value[0]];
    BOOL added = class_addMethod(self, sel, newIMP, [methodSignature cStringUsingEncoding:NSASCIIStringEncoding]);
    
    return added;
}

- (id)_initWithInfo:(id)info {
    self = [super init];
    if (self) {
        _info = [info retain];
    }
    return self;
}

- (void)dealloc {
    [_info release];
    [super dealloc];
}

- (id)_valueForInfoKey:(NSString *)key {
    __block id value = nil;
    if ([_info isKindOfClass:[NSManagedObject class]]) {
        NSManagedObjectContext *moc = [_info managedObjectContext];
        [moc performBlockAndWait:^{
            value = [_info valueForKey:key];
        }];
    } else {
        value = [_info valueForKey:key];
    }
    return value;
}

- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"%@ %@", [super description], _info];
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[self class]]) { return NO; }
    
    NSString *myIdentifierKey = [[self class] _uniquelyIdentifyingAPIKey];
    NSString *otherIdentifierKey = [[object class] _uniquelyIdentifyingAPIKey];
    
    id value = [self _valueForInfoKey:myIdentifierKey];
    id otherValue = [object _valueForInfoKey:otherIdentifierKey];
    
    if (value && otherValue) {
        return [value isEqual:otherValue];
    }
    
    return [super isEqual:object];
}

@end
