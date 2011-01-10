//
//  _SKRequestBuilderTags.m
//  StackKit
//
//  Created by Dave DeLong on 1/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "_SKRequestBuilderTags.h"


@implementation _SKRequestBuilderTags

+ (Class) recognizedFetchEntity {
	return [SKTag class];
}

+ (NSSet *) recognizedPredicateKeyPaths {
	return [NSSet setWithObjects:
			SKTagCount,
			SKTagLastUsedDate,
			SKTagName,
			nil];
}

+ (NSSet *) recognizedSortDescriptorKeys {
	return [NSSet setWithObjects:
			SKTagCount,
			SKTagLastUsedDate,
			SKTagName,
			nil];
}

@end
