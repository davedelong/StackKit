//
//  _SKRequestBuilderUsers.m
//  StackKit
//
//  Created by Dave DeLong on 1/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "_SKRequestBuilderUsers.h"


@implementation _SKRequestBuilderUsers

+ (Class) recognizedFetchEntity {
	return [SKUser class];
}

+ (NSSet *) recognizedPredicateKeyPaths {
	return [NSSet setWithObjects:
			SKUserDisplayName,
			SKUserCreationDate,
			SKUserReputation,
			nil];
}

+ (NSSet *) recognizedSortDescriptorKeys {
	return [NSSet setWithObjects:
			SKUserDisplayName,
			SKUserCreationDate,
			SKUserReputation,
			nil];
}

@end
