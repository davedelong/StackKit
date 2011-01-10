//
//  _SKConcreteRequestBuilder.m
//  StackKit
//
//  Created by Dave DeLong on 1/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "_SKConcreteRequestBuilder.h"

@interface _SKConcreteRequestBuilder ()

@property (nonatomic, retain) NSError * error;

@end


@implementation _SKConcreteRequestBuilder
@synthesize fetchRequest;
@synthesize error;

- (id) initWithFetchRequest:(SKFetchRequest *)request {
	self = [super init];
	if (self) {
		fetchRequest = [request retain];
	}
	return self;
}

- (void) dealloc {
	[fetchRequest release];
	[super dealloc];
}

+ (Class) recognizedFetchEntity { return nil; }
+ (NSSet *) recognizedPredicateKeyPaths { return [NSSet set]; }
+ (NSSet *) requiredPredicateKeyPaths { return [NSSet set]; }
+ (NSSet *) recognizedSortDescriptorKeys { return [NSSet set]; }

@end
