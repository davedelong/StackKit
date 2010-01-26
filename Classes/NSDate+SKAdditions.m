//
//  NSDate+SKAdditions.m
//  StackKit
//
//  Created by Dave DeLong on 1/25/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "StackKit_Internal.h"


@implementation NSDate (SKAdditions)

+ (NSDate *) dateWithJSONString:(NSString *)json {
	//assumes the string is in the format /Date(####)/
	if ([json isKindOfClass:[NSNull class]]) {
		return nil;
	}
	NSString * substring = [json substringWithRange:NSMakeRange(6, [json length] - 8)];
	NSNumber * n = [[NSNumberFormatter basicFormatter] numberFromString:substring];
	
	NSTimeInterval secondsSince1970 = [n floatValue]/1000;
	
	return [NSDate dateWithTimeIntervalSince1970:secondsSince1970];
}

@end
