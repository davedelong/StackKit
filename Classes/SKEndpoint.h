//
//  SKEndpoint.h
//  StackKit
//
//  Created by Dave DeLong on 6/2/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SKFetchRequest;

@interface SKEndpoint : NSObject {
	NSMutableDictionary * query;
	NSString * path;
	NSError * error;
}

@property (readonly, retain) NSMutableDictionary * query;
@property (readonly, retain) NSString * path;
@property (readonly, retain) NSError * error;

+ (id) endpoint;
- (BOOL) validateFetchRequest:(SKFetchRequest *)request;

- (NSString *) apiPath;

- (NSURL *) APIURLForFetchRequest:(SKFetchRequest *)request;

@end
