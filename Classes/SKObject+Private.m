//
//  SKObject+Private.m
//  StackKit
//
//  Created by Dave DeLong on 1/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SKObject+Private.h"

@implementation SKObject (Private)

+ (NSDictionary *) APIAttributeToPropertyMapping {
	NSAssert(NO, ([NSString stringWithFormat:@"+[%@ %@] must be overridden", NSStringFromClass(self), NSStringFromSelector(_cmd)]));
	return nil;
}

+ (NSString *) dataKey {
	NSAssert(NO, ([NSString stringWithFormat:@"+[%@ %@] must be overridden", NSStringFromClass(self), NSStringFromSelector(_cmd)]));
	return nil;
}

+ (NSString *) propertyKeyFromAPIAttributeKey:(NSString *)key {
	NSDictionary * mappings = [self APIAttributeToPropertyMapping];
	if ([mappings objectForKey:key] != nil) {
		return [mappings objectForKey:key];
	}
	return key;
}

- (void) mergeInformationFromDictionary:(NSDictionary *)dictionary {
	return;
}

#pragma mark -
#pragma mark KVC Compliance

- (id) valueForUndefinedKey:(NSString *)key {
	NSString * newKey = [[self class] propertyKeyFromAPIAttributeKey:key];
	if (newKey != nil && [newKey isEqual:key] == NO) {
		//this is a new key! try again
		return [self valueForKey:newKey];
	}
	//eh, we couldn't find a replacement.  pass it on up the chain
	return [super valueForUndefinedKey:key];
}

@end
