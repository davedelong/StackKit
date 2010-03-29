//
//  SKObject+Private.h
//  StackKit
//
//  Created by Dave DeLong on 1/25/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKObject.h"

@class SKFetchRequest;

@interface SKObject ()

- (void) loadJSON:(NSDictionary *)jsonDictionary;
- (id) jsonObjectAtURL:(NSURL *)aURL;

+ (NSURL *) constructAPICallForBaseURL:(NSURL *)base relativePath:(NSString *)path query:(NSDictionary *)query;
+ (NSURL *) apiCallForFetchRequest:(SKFetchRequest *)request error:(NSError **)error;

@end
