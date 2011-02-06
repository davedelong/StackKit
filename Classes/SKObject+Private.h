//
//  SKObject+Private.h
//  StackKit
//
//  Created by Dave DeLong on 2/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKObject.h"

@interface SKObject ()

+ (NSString*)entityName;

+ (id) objectMergedWithDictionary:(NSDictionary *)dictionary inSite:(SKSite *)site;
- (void) mergeInformationFromAPIResponseDictionary:(NSDictionary *)dictionary;
- (id) willMergeValue:(id)value forProperty:(NSString *)property;

#pragma mark Class methods implemented by SKObject
// used in valueForKey:
+ (NSString *) propertyKeyFromAPIAttributeKey:(NSString *)key;

#pragma mark Class methods that should be overriden by subclasses
// used to help valueForKey: out so that we can request properties via the constants (SKQuestionID vs @"questionID", for example)
+ (NSDictionary *) APIAttributeToPropertyMapping;
// keys used to extract information from the JSON response
+ (NSString *) apiResponseDataKey;
+ (NSString *) apiResponseUniqueIDKey;

@end
