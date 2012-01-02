//
//  SKObject_Internal.h
//  StackKit
//
//  Created by Dave DeLong on 12/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StackKit/SKObject.h>

@interface SKObject ()

+ (NSString *)_entityName;
+ (NSArray *)APIKeysBackingProperties;
+ (NSString *)_uniquelyIdentifyingAPIKey;

+ (NSDictionary *)APIKeysToPropertyMapping;
+ (NSDictionary *)propertyToAPIKeysMapping;

+ (NSString *)_infoKeyForSelector:(SEL)selector;
+ (id)_transformValue:(id)value forReturnType:(Class)returnType;

- (id)_initWithInfo:(id)info;
- (id)_valueForInfoKey:(NSString *)key;

@end
