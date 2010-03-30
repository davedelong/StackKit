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
	NSPredicate * p = [NSPredicate predicateWithFormat:@"Id = 42"];
	NSExpression * l = [NSExpression expressionForKeyPath:@"Id"];
	
	id value = [p constantValueForLeftExpression:l];
	STAssertNotNil(value, @"value should not be nil");
	STAssertEqualObjects(value, [NSNumber numberWithInt:42], @"value should be 42");
	
	p = [NSPredicate predicateWithFormat:@"(Foo = 13 AND Bar = \"Foo\") OR (Id = 42)"];
	value = [p constantValueForLeftExpression:l];
	STAssertNotNil(value, @"value should not be nil");
	STAssertEqualObjects(value, [NSNumber numberWithInt:42], @"value should be 42");
	
	p = [NSPredicate predicateWithFormat:@"Foo = 13"];
	value = [p constantValueForLeftExpression:l];
	STAssertNil(value, @"value should be nil");
}

@end
