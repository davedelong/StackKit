//
//  SKObject_Internal.h
//  StackKit
//
//  Created by Dave DeLong on 12/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StackKit/SKObject.h>

@class SKFetchRequest;

@interface SKObject ()

+ (NSString *)_entityName;
+ (NSArray *)APIKeysBackingProperties;
+ (NSString *)_uniquelyIdentifyingAPIKey;
+ (NSDictionary *)_mutateResponseDictionary:(NSDictionary *)d;

+ (NSString *)inferredPropertyNameFromAPIKey:(NSString *)apiKey;
+ (NSDictionary *)APIKeysToPropertyMapping;
+ (NSDictionary *)propertyToAPIKeysMapping;

+ (NSString *)_infoKeyForSelector:(SEL)selector;
+ (id)_transformValue:(id)value forReturnType:(Class)returnType;

- (id)_initWithInfo:(id)info site:(SKSite *)site;
- (id)_valueForInfoKey:(NSString *)key;
- (id)_info;

- (SKFetchRequest *)_fullObjectRequest;

@end
