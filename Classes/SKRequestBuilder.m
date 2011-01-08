//
//  SKRequestBuilder.m
//  StackKit
//
//  Created by Dave DeLong on 1/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SKRequestBuilder.h"
#import "SKRequestBuilder+Private.h"
#import <objc/runtime.h>

BOOL sk_classIsSubclassOfClass(Class aClass, Class targetSuper) {
	Class aSuper = nil;
	while ((aSuper = class_getSuperclass(aClass)) != nil) {
		if (aSuper == targetSuper) { return YES; }
		aClass = aSuper;
	}
	return NO;
}

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
				if (sk_classIsSubclassOfClass(thisClass, [SKRequestBuilder class])) {
					[_requestBuilderClasses addObject:thisClass];
				}
			}
			free(allClasses);
		}
	}
	return _requestBuilderClasses;
}

+ (NSURL *) URLForFetchRequest:(SKFetchRequest *)request error:(NSError **)error {
	NSURL * url = nil;
	
	NSMutableArray * recognizers = [[self _requestBuilders] mutableCopy];
	NSMutableIndexSet * unrecognized = [NSMutableIndexSet indexSet];
	
	//cull out any request builders that don't recognize the request entity
	for (NSUInteger i = 0; i < [recognizers count]; ++i) {
		Class requestBuilder = [recognizers objectAtIndex:i];
		Class recognizedEntity = [requestBuilder recognizedFetchEntity];
		if (recognizedEntity == nil || recognizedEntity != [request entity]) {
			[unrecognized addIndex:i];
		}
	}
	
	if ([unrecognized count] > 0) {
		[recognizers removeObjectsAtIndexes:unrecognized];
		[unrecognized removeAllIndexes];
	}
	
	if ([recognizers count] == 0) {
		if (error) {
			*error = [NSError errorWithDomain:SKErrorDomain code:SKErrorCodeInvalidEntity userInfo:nil];
		}
		goto errorExit;
	}
	
	//cull out any recognizers that don't recognize the predicate keypaths
	NSSet * requestPredicateKeyPaths = [[request predicate] leftKeyPaths];
	for (NSUInteger i = 0; i < [recognizers count]; ++i) {
		Class requestBuilder = [recognizers objectAtIndex:i];
		Class recognizedEntity = [requestBuilder recognizedFetchEntity];
		if (recognizedEntity == nil) {
			[unrecognized addIndex:i];
		} else {
			NSSet * recognizedKeyPaths = [recognizedEntity recognizedPredicateKeyPaths];
			NSSet * unionedKeyPaths = [recognizedKeyPaths setByAddingObjectsFromSet:requestPredicateKeyPaths];
			if ([unionedKeyPaths count] > [recognizedKeyPaths count]) {
				//adding in the keypaths from the request predicate resulted in keypaths that this builder doesn't recognize
				[unrecognized addIndex:i];
			}
		}
	}
	
	if ([unrecognized count] > 0) {
		[recognizers removeObjectsAtIndexes:unrecognized];
		[unrecognized removeAllIndexes];
	}
	
	if ([recognizers count] == 0) {
		if (error) {
			*error = [NSError errorWithDomain:SKErrorDomain code:SKErrorCodeInvalidPredicate userInfo:nil];
		}
		goto errorExit;
	}

errorExit:
	[recognizers release];
	return url;
}

@end
