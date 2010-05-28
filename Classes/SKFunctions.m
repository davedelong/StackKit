//
//  SKFunctions.m
//  StackKit
//
//  Created by Dave DeLong on 5/26/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "StackKit_Internal.h"

id invalidPredicateErrorForFetchRequest(SKFetchRequest * request, NSDictionary * userInfo) {
	[request setError:[NSError errorWithDomain:SKErrorDomain code:SKErrorCodeInvalidPredicate userInfo:userInfo]];
	return nil;
}

NSNumber * SKExtractNumber(id object, Class type, SEL idGetter) {
	if ([object isKindOfClass:type]) {
		return [object performSelector:idGetter];
	} else if ([object isKindOfClass:[NSNumber class]]) {
		return object;
	} else {
		return [NSNumber numberWithInt:[[object description] intValue]];
	}
}

NSNumber * SKExtractUserID(id value) {
	return SKExtractNumber(value, [SKUser class], @selector(userID));
}

NSNumber * SKExtractBadgeID(id value) {
	return SKExtractNumber(value, [SKBadge class], @selector(badgeID));
}

NSNumber * SKExtractPostID(id value) {
	return SKExtractNumber(value, [SKPost class], @selector(postID));
}

NSNumber * SKExtractCommentID(id value) {
	return SKExtractNumber(value, [SKComment class], @selector(commentID));
}

NSString * SKExtractTagName(id value) {
	if ([value isKindOfClass:[NSString class]]) {
		return value;
	} else if ([value isKindOfClass:[SKTag class]]) {
		return [value name];
	} else {
		return [value description];
	}
}