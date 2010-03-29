//
//  NSDictionary+SKAdditions.m
//  StackKit
//
//  Created by Dave DeLong on 3/29/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "NSDictionary+SKAdditions.h"


@implementation NSDictionary (SKAdditions)

- (NSString *) queryString {
	if ([[self allKeys] count] == 0) { return nil; }
	NSMutableArray * queryArray = [NSMutableArray array];
	for (NSString * key in self) {
		[queryArray addObject:[NSString stringWithFormat:@"%@=%@",
							   [key stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
							   [[[self objectForKey:key] description] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
	}
	
	return [queryArray componentsJoinedByString:@"&"];
}

@end
