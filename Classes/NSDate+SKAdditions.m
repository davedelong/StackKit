//
//  NSDate+SKAdditions.m
//  StackKit
/**
  Copyright (c) 2011 Dave DeLong
 
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

- (NSString *) sk_queryString {
	NSNumber * n = [NSNumber numberWithDouble:[self timeIntervalSince1970]];
	return [n sk_queryString];
}

@end
