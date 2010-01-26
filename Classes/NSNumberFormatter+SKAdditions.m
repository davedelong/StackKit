//
//  NSNumberFormatter+SKAdditions.m
//  StackKit
//
//  Created by Dave DeLong on 1/25/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "NSNumberFormatter+SKAdditions.h"


@implementation NSNumberFormatter (SKAdditions)

+ (NSNumberFormatter *) basicFormatter {
	static NSNumberFormatter * basicFormatter = nil;
	if (basicFormatter == nil) {
		basicFormatter = [[NSNumberFormatter alloc] init];
		[basicFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
	}
	return basicFormatter;
}

@end
