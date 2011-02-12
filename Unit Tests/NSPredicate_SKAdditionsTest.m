//
//  NSPredicate_SKAdditionsTest.m
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

#import "NSPredicate_SKAdditionsTest.h"
#import <StackKit/StackKit.h>
#import "NSPredicate+SKAdditions.h"

@implementation NSPredicate_SKAdditionsTest

- (void) testValueForLeftExpression {
	NSPredicate * p = [NSPredicate predicateWithFormat:@"userID = 42"];
	NSExpression * l = [NSExpression expressionForKeyPath:@"userID"];
	
	id value = [p constantValueForLeftExpression:l];
	STAssertNotNil(value, @"value should not be nil");
	STAssertEqualObjects(value, [NSNumber numberWithInt:42], @"value should be 42");
	
	p = [NSPredicate predicateWithFormat:@"(Foo = 13 AND Bar = \"Foo\") OR (userID = 42)"];
	value = [p constantValueForLeftExpression:l];
	STAssertNotNil(value, @"value should not be nil");
	STAssertEqualObjects(value, [NSNumber numberWithInt:42], @"value should be 42");
	
	p = [NSPredicate predicateWithFormat:@"Foo = 13"];
	value = [p constantValueForLeftExpression:l];
	STAssertNil(value, @"value should be nil");
}

@end
