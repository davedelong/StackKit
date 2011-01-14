//
//  SKRequestBuilder.m
//  StackKit
//
//  Created by Dave DeLong on 1/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SKRequestBuilder.h"
#import "_SKConcreteRequestBuilder.h"
#import <objc/runtime.h>

@implementation SKRequestBuilder

+ (NSArray *) _requestBuilders {
	static NSMutableArray * _requestBuilderClasses = nil;
	if (_requestBuilderClasses == nil) {
		//autodiscover all subclasses of "SKRequestBuilder"
		_requestBuilderClasses = [[NSMutableArray alloc] init];
		
		int numClasses = objc_getClassList(NULL, 0);
		if (numClasses > 0) {
			Class * allClasses = malloc(numClasses * sizeof(Class));
			numClasses = objc_getClassList(allClasses, numClasses);
			
			for (int i = 0; i < numClasses; ++i) {
				Class thisClass = allClasses[i];
				/**
				 Why not use +isSubclassOfClass:?
				 Because one of the classes returned by objc_getClassList() is the NSZombie class,
				 and invoking *any* method on it will result in an NSZombie exception.  
				 Instead, we have to walk the isa chain ourselves.  Lame.
				 **/
				if (sk_classIsSubclassOfClass(thisClass, [_SKConcreteRequestBuilder class])) {
					[_requestBuilderClasses addObject:thisClass];
				}
			}
			free(allClasses);
		}
	}
	return _requestBuilderClasses;
}

+ (NSURL *) URLForFetchRequest:(SKFetchRequest *)fetchRequest error:(NSError **)error {
	NSURL * url = nil;
	NSError * buildError = nil;
	
	NSMutableArray * builders = [[SKRequestBuilder _requestBuilders] mutableCopy];
	
	[builders filterUsingPredicate:[NSPredicate predicateWithFormat:@"recognizedFetchEntity = %@", [fetchRequest entity]]];
	if ([fetchRequest entity] == nil || [builders count] == 0) {
		buildError = [NSError errorWithDomain:SKErrorDomain code:SKErrorCodeInvalidEntity userInfo:nil];
		goto errorExit;
	}
	
	if ([fetchRequest sortDescriptor] != nil) {
		[builders filterUsingPredicate:[NSPredicate predicateWithFormat:@"recognizedSortDescriptorKeys CONTAINS %@", [[fetchRequest sortDescriptor] key]]];
	}
	if ([builders count] == 0) {
		buildError = [NSError errorWithDomain:SKErrorDomain code:SKErrorCodeInvalidSort userInfo:nil];
		goto errorExit;
	}
	
	if ([fetchRequest predicate] != nil) {
		NSPredicate * p = [NSPredicate predicateWithFormat:@"recognizesAPredicate = YES"];
		[builders filterUsingPredicate:p];
		
		NSSet * leftKeyPaths = [[fetchRequest predicate] leftKeyPaths];
		p = [NSPredicate predicateWithFormat:@"recognizedPredicateKeyPaths.@count == 0 OR ALL %@ IN recognizedPredicateKeyPaths", leftKeyPaths];
		[builders filterUsingPredicate:p];
		
		p = [NSPredicate predicateWithFormat:@"ALL requiredPredicateKeyPaths IN %@", leftKeyPaths];
		[builders filterUsingPredicate:p];
	} else {
		//this request doesn't have a predicate
		//therefore, remove all builders that require certain left keypaths (because those could never be satisfied)
		[builders filterUsingPredicate:[NSPredicate predicateWithFormat:@"requiredPredicateKeyPaths.@count == 0"]];
	}
	if ([builders count] == 0) {
		buildError = [NSError errorWithDomain:SKErrorDomain code:SKErrorCodeInvalidPredicate userInfo:nil];
		goto errorExit;
	}
	
	NSLog(@"potential builders: %@", builders);
	
errorExit:
	[builders release];
	if (buildError != nil && error != nil) {
		*error = buildError;
	}
	return url;
}

@end
