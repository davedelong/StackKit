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
- (void) loadJSON:(NSDictionary *)jsonDictionary;
- (id) jsonObjectAtURL:(NSURL *)aURL;

+ (id) objectWithSite:(SKSite *)aSite dictionaryRepresentation:(NSDictionary *)dictionary;
- (id) initWithSite:(SKSite *)aSite dictionaryRepresentation:(NSDictionary *)dictionary;

+ (NSURL *) constructAPICallForBaseURL:(NSURL *)base relativePath:(NSString *)path query:(NSDictionary *)query;
+ (NSURL *) apiCallForFetchRequest:(SKFetchRequest *)request error:(NSError **)error;

@end
