//
//  SKTag+Private.m
//  StackKit
//
//  Created by Dave DeLong on 1/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SKTag+Private.h"
#import "SKTag+Public.h"

@implementation SKTag (Private)

@dynamic name;
@dynamic numberOfTaggedQuestions;
@dynamic questions;

+ (NSDictionary *) APIAttributeToPropertyMapping {
	static NSDictionary * _kSKTagMappings = nil;
	if (_kSKTagMappings == nil) {
		_kSKTagMappings = [[NSDictionary alloc] initWithObjectsAndKeys:
						   @"name", SKTagName,
						   @"numberOfTaggedQuestions", SKTagCount,
						   nil];
	}
	return _kSKTagMappings;
}

+ (NSString *) dataKey {
	return @"tags";
}

+ (NSString *) uniqueIDKey {
	return SKTagName;
}

- (void) mergeInformationFromDictionary:(NSDictionary *)dictionary {
	[self setName:[dictionary objectForKey:SKTagName]];
	[self setNumberOfTaggedQuestions:[dictionary objectForKey:SKTagCount]];
}

- (BOOL) isEqual:(id)object {
	if ([object isKindOfClass:[self class]] == NO) {
		return NO;
	}
	
	return ([[self name] isEqual:[object name]]);
}

@end
