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

NSString * const SKTagName = @"name";
NSString * const SKTagCount = @"count";
NSString * const SKTagsParticipatedInByUser = __SKUserID;

NSString * const SKTagNumberOfTaggedQuestions = @"tag_popular";
NSString * const SKTagLastUsedDate = @"tag_activity";

@implementation SKTag 

@dynamic name;
@dynamic numberOfTaggedQuestions;
@dynamic questions;

+ (NSDictionary *) APIAttributeToPropertyMapping {
	static NSDictionary * mapping = nil;
	if (!mapping) {
		mapping = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"name", SKTagName,
                    @"numberOfTaggedQuestions", SKTagCount,
                    nil];
	}
	return mapping;
}

+ (NSString *) apiResponseDataKey {
	return @"tags";
}

+ (NSString *) apiResponseUniqueIDKey {
    return SKTagName;
}

@end
