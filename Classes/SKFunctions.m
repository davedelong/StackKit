//
//  SKFunctions.m
//  StackKit
//
//  Created by Dave DeLong on 5/26/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "SKFunctions.h"
#import "SKConstants.h"
#import "SKFetchRequest.h"

id invalidPredicateErrorForFetchRequest(SKFetchRequest * request, NSDictionary * userInfo) {
	[request setError:[NSError errorWithDomain:SKErrorDomain code:SKErrorCodeInvalidPredicate userInfo:userInfo]];
	return nil;
}