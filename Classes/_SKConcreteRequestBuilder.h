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
	NSURL * URL;
	NSMutableDictionary * query;
	NSString * path;
}

@property (nonatomic, readonly) SKFetchRequest * fetchRequest;
@property (nonatomic, retain) NSError * error;
@property (nonatomic, readonly, retain) NSURL * URL;
@property (nonatomic, readonly) NSMutableDictionary * query;
@property (nonatomic, copy) NSString * path;

+ (Class) recognizedFetchEntity;
+ (BOOL) recognizesAPredicate;
+ (NSDictionary *) recognizedPredicateKeyPaths;
+ (NSSet *) requiredPredicateKeyPaths;
+ (BOOL) recognizesASortDescriptor;
+ (NSSet *) recognizedSortDescriptorKeys;

- (id) initWithFetchRequest:(SKFetchRequest *)request;

@end

@interface _SKConcreteRequestBuilder (SubclassMethods)

- (void) buildURL;
- (NSPredicate *) requestPredicate;
- (NSSortDescriptor *) requestSortDescriptor;

@end