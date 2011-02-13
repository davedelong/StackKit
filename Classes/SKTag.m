// 
//  SKTag.m
//  StackKit
//
//  Created by Dave DeLong on 1/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SKTag.h"
#import "SKConstants_Internal.h"
#import "SKObject+Private.h"

@implementation SKTag 

@dynamic name;
@dynamic numberOfTaggedQuestions;
@dynamic questions;

+ (NSDictionary *) APIAttributeToPropertyMapping {
    static NSDictionary * mapping = nil;
	if (!mapping) {
		mapping = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"name", SKAPIName,
                    @"numberOfTaggedQuestions", SKAPICount,
                    nil];
	}
	return mapping;
}

+ (NSString *) apiResponseDataKey {
	return @"tags";
}

+ (NSString *) apiResponseUniqueIDKey {
    return SKAPIName;
}

SK_GETTER(NSString *, name);
SK_GETTER(NSNumber *, numberOfTaggedQuestions);
SK_GETTER(NSSet*, questions);

@end
