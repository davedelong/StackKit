//
//  NSDictionary+SKAdditions.m
//  StackKit
/**
 Copyright (c) 2010 Dave DeLong
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 **/

#import "NSDictionary+SKAdditions.h"
#import "NSDate+SKAdditions.h"
#import "NSNumber+SKAdditions.h"
#import "NSString+SKAdditions.h"

@implementation NSDictionary (SKAdditions)

- (NSString *) queryString {
	if ([[self allKeys] count] == 0) { return @""; }
	NSMutableArray * queryArray = [NSMutableArray array];
	for (NSString * key in self) {
		id object = [self objectForKey:key];
		NSString * value = [object description];
		if ([object respondsToSelector:@selector(sk_queryString)]) {
			value = [object sk_queryString];
		}
		[queryArray addObject:[NSString stringWithFormat:@"%@=%@",
							   [key sk_URLEncodedString],
							   [value sk_URLEncodedString]]];
	}
	
	return [queryArray componentsJoinedByString:@"&"];
}

- (NSSet *) sk_allObjectsAndKeys {
	NSLog(@"%s", _cmd);
	NSMutableSet * all = [NSMutableSet setWithArray:[self allKeys]];
	[all addObjectsFromArray:[self allValues]];
	return all;
}

@end
