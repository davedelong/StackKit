//
//  NSNumber+SKAdditions.m
//  StackKit
//
//  Created by Dave DeLong on 1/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSNumber+SKAdditions.h"


@implementation NSNumber (SKAdditions)

- (NSString *) sk_queryString {
	return [NSString stringWithFormat:@"%ld", [self integerValue]];
}

@end
