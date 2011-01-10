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
	SKFetchRequest * fetchRequest;
}

@property (nonatomic, readonly) SKFetchRequest * fetchRequest;
@property (nonatomic, readonly, retain) NSError * error;

+ (Class) recognizedFetchEntity;
+ (NSSet *) recognizedPredicateKeyPaths;
+ (NSSet *) requiredPredicateKeyPaths;
+ (NSSet *) recognizedSortDescriptorKeys;

- (id) initWithFetchRequest:(SKFetchRequest *)request;

@end
