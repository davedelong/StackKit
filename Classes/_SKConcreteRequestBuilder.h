//
//  _SKConcreteRequestBuilder.h
//  StackKit
//
//  Created by Dave DeLong on 1/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StackKit_Internal.h"

@interface _SKConcreteRequestBuilder : NSObject {
	@private
	SKFetchRequest * fetchRequest;
	NSError * error;
	NSMutableDictionary * query;
	NSString * path;
}

@property (nonatomic, readonly) SKFetchRequest * fetchRequest;
@property (nonatomic, readonly, retain) NSError * error;
@property (nonatomic, readonly) NSMutableDictionary * query;
@property (nonatomic, copy) NSString * path;

+ (Class) recognizedFetchEntity;
+ (BOOL) recognizesAPredicate;
+ (NSDictionary *) recognizedPredicateKeyPaths;
+ (NSSet *) requiredPredicateKeyPaths;
+ (NSSet *) recognizedSortDescriptorKeys;

- (id) initWithFetchRequest:(SKFetchRequest *)request;

- (NSURL *) URL;

@end
