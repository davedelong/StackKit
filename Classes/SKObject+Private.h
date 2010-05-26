//
//  SKObject+Private.h
//  StackKit
//
//  Created by Dave DeLong on 1/25/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKObject.h"

@class SKSite;
@class SKFetchRequest;

@interface SKObject ()

- (void) setSite:(SKSite *)newSite;

+ (id) objectWithSite:(SKSite *)aSite dictionaryRepresentation:(NSDictionary *)dictionary;
- (id) initWithSite:(SKSite *)aSite dictionaryRepresentation:(NSDictionary *)dictionary;

#pragma mark Class methods implemented by SKObject
+ (NSURL *) constructAPICallForBaseURL:(NSURL *)base relativePath:(NSString *)path query:(NSDictionary *)query;
+ (NSString *) propertyKeyFromAPIAttributeKey:(NSString *)key;

#pragma mark Class methods that should be overriden by subclasses
+ (NSURL *) apiCallForFetchRequest:(SKFetchRequest *)request;
+ (NSDictionary *) APIAttributeToPropertyMapping;

+ (NSDictionary *) validSortDescriptorKeys;

@end
