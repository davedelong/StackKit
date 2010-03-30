//
//  NSPredicate_SKAdditionsTest.m
//  StackKit
//
//  Created by Dave DeLong on 3/29/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "NSPredicate_SKAdditionsTest.h"
#import <StackKit/StackKit.h>
#import "NSPredicate+SKAdditions.h"

@implementation NSPredicate_SKAdditionsTest

- (void) testValueForLeftExpression {
	NSPredicate * p = [NSPredicate predicateWithFormat:@"%K = 42", SKUserID];
	NSExpression * l = [NSExpression expressionForKeyPath:SKUserID];
	
	id value = [p constantValueForLeftExpression:l];
	STAssertNotNil(value, @"value should not be nil");
	STAssertEqualObjects(value, [NSNumber numberWithInt:42], @"value should be 42");
	
	p = [NSPredicate predicateWithFormat:@"(Foo = 13 AND Bar = \"Foo\") OR (%K = 42)", SKUserID];
	value = [p constantValueForLeftExpression:l];
	STAssertNotNil(value, @"value should not be nil");
	STAssertEqualObjects(value, [NSNumber numberWithInt:42], @"value should be 42");
	
	p = [NSPredicate predicateWithFormat:@"Foo = 13"];
	value = [p constantValueForLeftExpression:l];
	STAssertNil(value, @"value should be nil");
}

@end
