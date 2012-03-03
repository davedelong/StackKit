//
//  SKAPI.m
//  StackKit
//
//  Created by Dave DeLong on 2/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SKAPI.h"
#import <StackKit/SKFunctions.h>
#import <StackKit/SKMacros.h>
#import <CoreData/CoreData.h>

NSString *const SKAPIEntityNameKey = @"name";
NSString *const SKAPIEntityFieldsKey = @"fields";
NSString *const SKAPIEntityUniqueFieldKey = @"uniqueField";

NSString *const SKAPITypeString = @"string";
NSString *const SKAPITypeInteger = @"integer";
NSString *const SKAPITypeDate = @"date";
NSString *const SKAPITypeDecimal = @"decimal";
NSString *const SKAPITypeBoolean = @"boolean";

@implementation SKAPI {
    dispatch_queue_t apiQueue;
    NSArray *_apiDefinition;
    
    NSArray *_entities;
    NSDictionary *_entitiesByName;
}

+ (id)api {
    static SKAPI *api = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        api = [[SKAPI alloc] init];
    });
    return api;
}

- (id)init {
    self = [super init];
    if (self) {
        apiQueue = dispatch_queue_create("com.davedelong.stackkit.apiqueue", 0);
    }
    return self;
}

- (NSArray *)_apiDefinition {
    REQUIRE_QUEUE(apiQueue);
    if (_apiDefinition == nil) {
        NSString *path = [SKBundle() pathForResource:@"SKAPI" ofType:@"plist"];
        _apiDefinition = [[NSArray alloc] initWithContentsOfFile:path];
    }
    return _apiDefinition;
}

- (void)_makeEntities {
    REQUIRE_QUEUE(apiQueue);
    NSArray *def = [self _apiDefinition];
    
    
    NSMutableArray *builtEntities = [NSMutableArray array];
    NSMutableDictionary *entitiesByName = [NSMutableDictionary dictionary];
    
    for (NSDictionary *entityDefinition in def) {
        NSString *entityName = [entityDefinition objectForKey:SKAPIEntityNameKey];
        NSEntityDescription *entity = [[NSEntityDescription alloc] init];
        [entity setName:entityName];
        [entity setManagedObjectClassName:@"SKManagedObject"];
        
        [entitiesByName setObject:entity forKey:entityName];
        [builtEntities addObject:entity];
        [entity release];
    }
    
    for (NSDictionary *entityDefinition in def) {
        NSString *entityName = [entityDefinition objectForKey:SKAPIEntityNameKey];
        NSDictionary *fields = [entityDefinition objectForKey:SKAPIEntityFieldsKey];
        NSString *uniqueField = [entityDefinition objectForKey:SKAPIEntityUniqueFieldKey];
        
        NSMutableArray *properties = [NSMutableArray array];
        for (NSString *fieldName in fields) {
            id value = [fields objectForKey:fieldName];
            NSPropertyDescription *property = [self _propertyDescriptionForKey:fieldName value:value entities:entitiesByName];
            if (property != nil) {
                [properties addObject:property];
            } else {
                NSLog(@"%@.%@ => %@", [entityDefinition objectForKey:SKAPIEntityNameKey], fieldName, value);
            }
        }
        
        NSEntityDescription *entity = [entitiesByName objectForKey:entityName];
        [entity setProperties:properties];
        
        if (uniqueField != nil) {
            NSPropertyDescription *uniqueProperty = [[entity propertiesByName] objectForKey:uniqueField];
            if (uniqueProperty != nil) {
                [uniqueProperty setOptional:NO];
            } else {
                NSLog(@"unique property mismatch: %@", uniqueField);
            }
        }
    }
    
    _entities = [[builtEntities copy] autorelease];
    _entitiesByName = [[entitiesByName copy] autorelease];
}

- (NSPropertyDescription *)_propertyDescriptionForKey:(NSString *)key value:(id)value entities:(NSDictionary *)entities {
    NSPropertyDescription *property = nil;
    
    if ([value isKindOfClass:[NSArray class]]) {
        // this is for enum-like values
        // we know this must be an NSAttributeDescription
        NSAttributeDescription *attribute = [[NSAttributeDescription alloc] init];
        [attribute setAttributeType:NSStringAttributeType];
        
        property = attribute;
    } else if ([value isKindOfClass:[NSString class]]) {
        NSString *kind = value;
        
        NSAttributeType attributeType = NSUndefinedAttributeType;
        if ([kind isEqualToString:SKAPITypeString]) {
            attributeType = NSStringAttributeType;
        } else if ([kind isEqualToString:SKAPITypeInteger]) {
            attributeType = NSInteger64AttributeType;
        } else if ([kind isEqualToString:SKAPITypeDate]) {
            attributeType = NSDateAttributeType;
        } else if ([kind isEqualToString:SKAPITypeDecimal]) {
            attributeType = NSDecimalAttributeType;
        } else if ([kind isEqualToString:SKAPITypeBoolean]) {
            attributeType = NSBooleanAttributeType;
        }
        
        if (attributeType != NSUndefinedAttributeType) {
            NSAttributeDescription *attribute = [[NSAttributeDescription alloc] init];
            [attribute setAttributeType:attributeType];
            property = attribute;
        } else {
            // either a plural (strings) or a relationship (user, users, etc)
        }
    }
    
    [property setName:key];
    return [property autorelease];
}

- (NSArray *)entities {
    __block NSArray *entities = nil;
    dispatch_sync(apiQueue, ^{
        if (_entities == nil) {
            [self _makeEntities];
        }
        entities = _entities;
    });
    return entities;
}

- (NSDictionary *)entitiesByName {
    __block NSDictionary *entitiesByName = nil;
    dispatch_sync(apiQueue, ^{
        if (_entities == nil) {
            [self _makeEntities];
        }
        entitiesByName = _entitiesByName;
    });
    return entitiesByName;
}



@end
