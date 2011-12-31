//
//  SKObject_Internal.h
//  StackKit
//
//  Created by Dave DeLong on 12/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StackKit/SKObject.h>
#import <objc/runtime.h>

@interface SKObject ()

+ (NSString *)_infoKeyForProperty:(objc_property_t)property;
+ (id)_transformValue:(id)value forReturnType:(Class)returnType;

- (id)_initWithInfo:(id)info;
- (id)_valueForInfoKey:(NSString *)key;

@end
