//
//  SKRequestBuilder.m
//  StackKit
/**
  Copyright (c) 2011 Dave DeLong
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 **/

#import "SKRequestBuilder.h"
#import "_SKConcreteRequestBuilder.h"
#import "SKMacros.h"
#import <objc/runtime.h>

@implementation SKRequestBuilder

+ (NSArray *) _requestBuilders {
    static dispatch_once_t onceToken;
	static NSMutableArray * _requestBuilderClasses = nil;
    dispatch_once(&onceToken, ^{
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
    });
    
	return _requestBuilderClasses;
}

+ (NSURL *) URLForFetchRequest:(SKFetchRequest *)fetchRequest error:(NSError **)error {
	NSURL * url = nil;
	NSError * buildError = nil;
	
	NSMutableArray * builders = [[SKRequestBuilder _requestBuilders] mutableCopy];
	
	[builders filterUsingPredicate:[NSPredicate predicateWithFormat:@"recognizedFetchEntity = %@", [fetchRequest entity]]];
	if ([fetchRequest entity] == nil || [builders count] == 0) {
		buildError = SK_ENTERROR(@"Unrecognized fetch entity: %@", NSStringFromClass([fetchRequest entity]));
		goto errorExit;
	}
	
	if ([fetchRequest sortDescriptor] != nil) {
		[builders filterUsingPredicate:[NSPredicate predicateWithFormat:@"recognizesASortDescriptor = YES"]];
		[builders filterUsingPredicate:[NSPredicate predicateWithFormat:@"allRecognizedSortDescriptorKeys CONTAINS %@", [[fetchRequest sortDescriptor] key]]];
	}
	if ([builders count] == 0) {
		buildError = SK_SORTERROR(@"Unrecognized sort key: %@", [[fetchRequest sortDescriptor] key]);
		goto errorExit;
	}
	
	if ([fetchRequest predicate] != nil) {
		if ([[fetchRequest predicate] isKindOfClass:[NSCompoundPredicate class]] && [[fetchRequest predicate] sk_isSimpleAndPredicate] == NO) {
			buildError = SK_PREDERROR(@"Only comparison predicates and AND predicates with no compound subpredicates are recognized");
			goto errorExit;
		}
		//some endpoints do not recognize a predicate
		NSPredicate * p = [NSPredicate predicateWithFormat:@"recognizesAPredicate = YES"];
		[builders filterUsingPredicate:p];
		if ([builders count] == 0) {
			buildError = SK_PREDERROR(@"no possible builders are recognizers");
			goto errorExit;
		}
		
		NSSet * leftKeyPaths = [[fetchRequest predicate] sk_leftKeyPaths];
		
		//the predicate must only use recognized keypaths
		p = [NSPredicate predicateWithFormat:@"recognizedPredicateKeyPaths.@count == 0 OR ALL %@ IN recognizedPredicateKeyPaths.@allKeys", leftKeyPaths];
		[builders filterUsingPredicate:p];
		if ([builders count] == 0) {
			buildError = SK_PREDERROR(@"predicate uses unrecognized keypaths");
			goto errorExit;
		}
		
		//the predicate must have any required keypaths
		p = [NSPredicate predicateWithFormat:@"ALL requiredPredicateKeyPaths IN %@", leftKeyPaths];
		[builders filterUsingPredicate:p];
		if ([builders count] == 0) {
			buildError = SK_PREDERROR(@"predicate does not have all required keypaths");
			goto errorExit;
		}
		
		//the predicate must only use certain operators for certain keypaths
		p = [NSPredicate predicateWithFormat:@"FUNCTION(%@, 'sk_matchesRecognizedKeyPathsAndOperators:', SELF.recognizedPredicateKeyPaths) == YES", [fetchRequest predicate]];
		[builders filterUsingPredicate:p];
		if ([builders count] == 0) {
			buildError = SK_PREDERROR(@"predicate uses invalid operators for keypaths");
			goto errorExit;
		}
		
	} else {
		//this request doesn't have a predicate
		//therefore, keep only the builders that don't require any left keypaths
		[builders filterUsingPredicate:[NSPredicate predicateWithFormat:@"requiredPredicateKeyPaths.@count == 0"]];
		if ([builders count] == 0) {
			buildError = SK_PREDERROR(@"no possible builders recognize an empty predicate");
			goto errorExit;
		}
	}
	if ([builders count] == 0) {
		if (buildError == nil) {
			buildError = SK_PREDERROR(@"Invalid predicate structure");
		}
		goto errorExit;
	}
	
	NSMutableArray * successfulBuilders = [NSMutableArray array];
	NSMutableArray * failedBuilders = [NSMutableArray array];
	for (Class builder in builders) {
		_SKConcreteRequestBuilder * concreteBuilder = [[builder alloc] initWithFetchRequest:fetchRequest];
		if ([concreteBuilder error] != nil) {
			[failedBuilders addObject:concreteBuilder];
		} else {
			[successfulBuilders addObject:concreteBuilder];
		}
		[concreteBuilder release];
	}
	
	if ([successfulBuilders count] > 0) {
		//something succeeded!
		_SKConcreteRequestBuilder * successfulBuilder = [successfulBuilders objectAtIndex:0];
		buildError = nil;
		url = [successfulBuilder URL];
		
		if ([successfulBuilders count] > 1) {
			SKLog(@"multiple URLs built: %@", [successfulBuilders valueForKey:@"URL"]);
		}
	} else if ([failedBuilders count] > 0) {
		//nothing succeeded and something failed
		_SKConcreteRequestBuilder * failedBuilder = [failedBuilders objectAtIndex:0];
		buildError = [failedBuilder error];
		url = nil;
	} else {
		//nothing succeeded and nothing failed
		//this should be impossible
		SKLog(@"Impossible branch reached!");
	}
	
errorExit:
	[builders release];
	if (buildError != nil) {
		SKLog(@"build error: %@", buildError);
		if (error != nil) {
			*error = buildError;
		}
	}
	return url;
}

@end
